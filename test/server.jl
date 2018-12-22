using Distributed

while nworkers() < 5
    addprocs(1)
end

@everywhere using HTTPA, Sockets, Test

"""
    n: number of remotes
    m: number of async requests per remote
"""
function testget(url, n=1, m=1)
    r = []
    @sync for i in 1:n
        @async push!(r, remote((url, mm) -> begin
            rr = []
            @sync for ii in 1:mm
                l = rand([0,0,10,1000,10000])
                body = Vector{UInt8}(rand('A':'Z', l))
                # println("sending request...")
                @async push!(rr, HTTPA.request("GET", "$url/$ii", [], body))
            end
            return rr
        end)("$url/$i", m))
    end
    return join([String(x) for x in vcat(r...)], "\n")
end

@testset "HTTPA.listen" begin

port = 8087 # rand(8000:8999)

# echo response
handler = (http) -> begin
    request::HTTPA.Request = http.message
    request.body = read(http)
    closeread(http)
    request.response::HTTPA.Response = HTTPA.Response(request.body)
    request.response.request = request
    startwrite(http)
    write(http, request.response.body)
end

server = Sockets.listen(Sockets.InetAddr(parse(IPAddr, "127.0.0.1"), port))
tsk = @async HTTPA.listen(handler, "127.0.0.1", port; server=server)
sleep(3.0)
r = testget("http://127.0.0.1:$port")
@test occursin(r"HTTPA/1.1 200 OK", r)
close(server)
sleep(1.0)
@test istaskdone(tsk)

tsk = @async HTTPA.listen(handler, "127.0.0.1", port)

handler2 = HTTPA.Handlers.RequestHandlerFunction(req->HTTPA.Response(200, req.body))

tsk2 = @async HTTPA.serve(handler2, "127.0.0.1", port+100)
sleep(3.0)

r = testget("http://127.0.0.1:$port")
@test occursin(r"HTTPA/1.1 200 OK", r)

r = testget("http://127.0.0.1:$(port+100)")
@test occursin(r"HTTPA/1.1 200 OK", r)

rv = []
n = 5
m = 20
@sync for i = 1:n
    @async begin
        r = testget("http://127.0.0.1:$port/$i", n, m)
        #println(r)
        push!(rv, r)
    end
    sleep(0.01)
end
for i = 1:n
    @test length(filter(l->occursin(r"HTTPA/1.1 200 OK", l),
                        split(rv[i], "\n"))) == n * m
end

r = HTTPA.get("http://127.0.0.1:$port/"; readtimeout=30)
@test r.status == 200
@test String(r.body) == ""

# large headers
tcp = Sockets.connect(ip"127.0.0.1", port)
x = "GET / HTTPA/1.1\r\n$(repeat("Foo: Bar\r\n", 10000))\r\n";
@show length(x)
write(tcp, "GET / HTTPA/1.1\r\n$(repeat("Foo: Bar\r\n", 10000))\r\n")
sleep(0.1)
@test occursin(r"HTTPA/1.1 413 Request Entity Too Large", String(read(tcp)))

# invalid HTTPA
tcp = Sockets.connect(ip"127.0.0.1", port)
write(tcp, "GET / HTP/1.1\r\n\r\n")
sleep(0.1)
@test occursin(r"HTTPA/1.1 400 Bad Request", String(readavailable(tcp)))

# no URL
tcp = Sockets.connect(ip"127.0.0.1", port)
write(tcp, "SOMEMETHOD HTTPA/1.1\r\nContent-Length: 0\r\n\r\n")
sleep(0.1)
r = String(readavailable(tcp))
@test occursin(r"HTTPA/1.1 400 Bad Request", r)

# Expect: 100-continue
tcp = Sockets.connect(ip"127.0.0.1", port)
write(tcp, "POST / HTTPA/1.1\r\nContent-Length: 15\r\nExpect: 100-continue\r\n\r\n")
sleep(0.1)
client = String(readavailable(tcp))
@test client == "HTTPA/1.1 100 Continue\r\n\r\n"

write(tcp, "Body of Request")
sleep(0.1)
client = String(readavailable(tcp))

println("client:")
println(client)
@test occursin("HTTPA/1.1 200 OK\r\n", client)
@test occursin("Transfer-Encoding: chunked\r\n", client)
@test occursin("Body of Request", client)

hello = (http) -> begin
    request::HTTPA.Request = http.message
    request.body = read(http)
    closeread(http)
    request.response::HTTPA.Response = HTTPA.Response("Hello")
    request.response.request = request
    startwrite(http)
    write(http, request.response.body)
end
# keep-alive vs. close: issue #81
port += 1
tsk = @async HTTPA.listen(hello, "127.0.0.1", port,verbose=true) 
sleep(2.0)
tcp = Sockets.connect(ip"127.0.0.1", port)
write(tcp, "GET / HTTPA/1.0\r\n\r\n")
sleep(0.5)
client = String(readavailable(tcp))
@show client
@test client == "HTTPA/1.1 200 OK\r\n\r\nHello"

# body too big

# other bad requests

# SO_REUSEPORT
println("Testing server port reuse")
t1 = @async HTTPA.listen(hello, "127.0.0.1", 8089; reuseaddr=true)
@test !istaskdone(t1)
sleep(0.5)

println("Starting second server listening on same port")
t2 = @async HTTPA.listen(hello, "127.0.0.1", 8089; reuseaddr=true)
@test !istaskdone(t2)
sleep(0.5)

println("Starting server on same port without port reuse (throws error)")
try
    HTTPA.listen(hello, "127.0.0.1", 8089)
catch e
    @test e isa Base.IOError
    @test startswith(e.msg, "listen")
    @test e.code == Base.UV_EADDRINUSE
end

# test automatic forwarding of non-sensitive headers
# this is a server that will "echo" whatever headers were sent to it
t1 = @async HTTPA.listen("127.0.0.1", 8090) do http
    request::HTTPA.Request = http.message
    request.body = read(http)
    closeread(http)
    request.response::HTTPA.Response = HTTPA.Response(200, request.headers)
    request.response.request = request
    startwrite(http)
    write(http, request.response.body)
end
@test !istaskdone(t1)
sleep(0.5)

# test that an Authorization header is **not** forwarded to a domain different than initial request
r = HTTPA.get("http://httpbin.org/redirect-to?url=http://127.0.0.1:8090", ["Authorization"=>"auth"])
@test !HTTPA.hasheader(r, "Authorization")

# test that an Authorization header **is** forwarded to redirect in same domain
r = HTTPA.get("http://httpbin.org/redirect-to?url=https://httpbin.org/response-headers?Authorization=auth")
@test HTTPA.hasheader(r, "Authorization")

end # @testset
