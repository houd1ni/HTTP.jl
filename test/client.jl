using HTTPA, Test, JSON

@testset "HTTPA.Client" begin

status(r) = r.status

for sch in ("http", "https")
    println("running $sch client tests...")

    println("simple GET, HEAD, POST, DELETE, etc.")
    @test status(HTTPA.get("$sch://httpbin.org/ip")) == 200
    @test status(HTTPA.head("$sch://httpbin.org/ip")) == 200
    @test status(HTTPA.post("$sch://httpbin.org/ip"; status_exception=false)) == 405
    @test status(HTTPA.post("$sch://httpbin.org/post")) == 200
    @test status(HTTPA.put("$sch://httpbin.org/put")) == 200
    @test status(HTTPA.delete("$sch://httpbin.org/delete")) == 200
    @test status(HTTPA.patch("$sch://httpbin.org/patch")) == 200

    # Testing within tasks, see https://github.com/JuliaWeb/HTTPA.jl/issues/18
    println("async client request")
    @test status(fetch(@async HTTPA.get("$sch://httpbin.org/ip"))) == 200

    @test status(HTTPA.get("$sch://httpbin.org/encoding/utf8")) == 200

    println("pass query to uri")
    r = HTTPA.get(merge(HTTPA.URI("$sch://httpbin.org/response-headers"); query=Dict("hey"=>"dude")))
    h = Dict(r.headers)
    @test (haskey(h, "Hey") ? h["Hey"] == "dude" : h["hey"] == "dude")

    println("cookie requests")
    empty!(HTTPA.CookieRequest.default_cookiejar)
    r = HTTPA.get("$sch://httpbin.org/cookies", cookies=true)
    body = String(r.body)
    @test replace(replace(body, " "=>""), "\n"=>"")  == "{\"cookies\":{}}"
    r = HTTPA.get("$sch://httpbin.org/cookies/set?hey=sailor&foo=bar", cookies=true)
    @test status(r) == 200
    body = String(r.body)
    @test replace(replace(body, " "=>""), "\n"=>"")  == "{\"cookies\":{\"foo\":\"bar\",\"hey\":\"sailor\"}}"

    r = HTTPA.get("$sch://httpbin.org/cookies/delete?hey")
    @test isempty(JSON.parse(String(r.body))["cookies"])

    # stream
    println("client streaming tests")
    r = HTTPA.post("$sch://httpbin.org/post"; body="hey")
    @test status(r) == 200
    # stream, but body is too small to actually stream
    r = HTTPA.post("$sch://httpbin.org/post"; body="hey", stream=true)
    @test status(r) == 200
    r = HTTPA.get("$sch://httpbin.org/stream/100")
    @test status(r) == 200
    bytes = r.body
    a = [JSON.parse(l) for l in split(chomp(String(bytes)), "\n")]
    totallen = length(bytes) # number of bytes to expect
    begin
        io = Base.BufferStream()
        r = HTTPA.get("$sch://httpbin.org/stream/100"; response_stream=io)
        @test status(r) == 200

        b = [JSON.parse(l) for l in eachline(io)]
        @test a == b
    end

    # body posting: Vector{UInt8}, String, IOStream, IOBuffer, Base.BufferStream
    println("client body posting of various types")
    @test status(HTTPA.post("$sch://httpbin.org/post"; body="hey")) == 200
    @test status(HTTPA.post("$sch://httpbin.org/post"; body=UInt8['h','e','y'])) == 200
    io = IOBuffer("hey"); seekstart(io)
    @test status(HTTPA.post("$sch://httpbin.org/post"; body=io)) == 200
    tmp = tempname()
    open(f->write(f, "hey"), tmp, "w")
    io = open(tmp)
    @test status(HTTPA.post("$sch://httpbin.org/post"; body=io, enablechunked=false)) == 200
    close(io); rm(tmp)
    f = Base.BufferStream()
    write(f, "hey")
    close(f)
    @test status(HTTPA.post("$sch://httpbin.org/post"; body=f, enablechunked=false)) == 200

    # chunksize
    #
    #     https://github.com/JuliaWeb/HTTPA.jl/issues/60
    #     Currently httpbin.org responds with 411 status and “Length Required”
    #     message to any POST/PUT requests that are sent using chunked encoding
    #     See https://github.com/kennethreitz/httpbin/issues/340#issuecomment-330176449
    println("client transfer-encoding chunked")
    @test status(HTTPA.post("$sch://httpbin.org/post"; body="hey", #=chunksize=2=#)) == 200
    @test status(HTTPA.post("$sch://httpbin.org/post"; body=UInt8['h','e','y'], #=chunksize=2=#)) == 200
    io = IOBuffer("hey"); seekstart(io)
    @test status(HTTPA.post("$sch://httpbin.org/post"; body=io, #=chunksize=2=#)) == 200
    tmp = tempname()
    open(f->write(f, "hey"), tmp, "w")
    io = open(tmp)
    @test status(HTTPA.post("$sch://httpbin.org/post"; body=io, #=chunksize=2=#)) == 200
    close(io); rm(tmp)
    f = Base.BufferStream()
    write(f, "hey")
    close(f)
    @test status(HTTPA.post("$sch://httpbin.org/post"; body=f, #=chunksize=2=#)) == 200

    # multipart
    # println("client multipart body")
    # r = HTTPA.post("$sch://httpbin.org/post"; body=Dict("hey"=>"there"))
    # @test status(r) == 200
    # @test startswith(replace(replace(String(r.body), " "=>""), "\n"=>""), "{\"args\":{},\"data\":\"\",\"files\":{},\"form\":{\"hey\":\"there\"}")

    # r = HTTPA.post("$sch://httpbin.org/post"; body=Dict("hey"=>"there"))
    # @test status(r) == 200
    # @test startswith(replace(replace(String(r.body), " "=>""), "\n"=>""), "{\"args\":{},\"data\":\"\",\"files\":{},\"form\":{\"hey\":\"there\"}")

    # tmp = tempname()
    # open(f->write(f, "hey"), tmp, "w")
    # io = open(tmp)
    # r = HTTPA.post("$sch://httpbin.org/post"; body=Dict("hey"=>"there", "iostream"=>io))
    # close(io); rm(tmp)
    # @test status(r) == 200
    # str = replace(replace(String(r.body), " "=>""), "\n"=>"")
    # @test startswith(str, "{\"args\":{},\"data\":\"\",\"files\":{\"iostream\":\"hey\"},\"form\":{\"hey\":\"there\"}")

    # tmp = tempname()
    # open(f->write(f, "hey"), tmp, "w")
    # io = open(tmp)
    # r = HTTPA.post("$sch://httpbin.org/post"; body=Dict("hey"=>"there", "iostream"=>io))
    # close(io); rm(tmp)
    # @test status(r) == 200
    # @test startswith(replace(replace(String(r.body), " "=>""), "\n"=>""), "{\"args\":{},\"data\":\"\",\"files\":{\"iostream\":\"hey\"},\"form\":{\"hey\":\"there\"}")

    # tmp = tempname()
    # open(f->write(f, "hey"), tmp, "w")
    # io = open(tmp)
    # m = HTTPA.Multipart("mycoolfile.txt", io)
    # r = HTTPA.post("$sch://httpbin.org/post"; body=Dict("hey"=>"there", "multi"=>m))
    # close(io); rm(tmp)
    # @test status(r) == 200
    # @test startswith(replace(replace(String(r.body), " "=>""), "\n"=>""), "{\"args\":{},\"data\":\"\",\"files\":{\"multi\":\"hey\"},\"form\":{\"hey\":\"there\"}")

    # tmp = tempname()
    # open(f->write(f, "hey"), tmp, "w")
    # io = open(tmp)
    # m = HTTPA.Multipart("mycoolfile", io, "application/octet-stream")
    # r = HTTPA.post("$sch://httpbin.org/post"; body=Dict("hey"=>"there", "multi"=>m), #=chunksize=1000=#)
    # close(io); rm(tmp)
    # @test status(r) == 200
    # @test startswith(replace(replace(String(r.body), " "=>""), "\n"=>""), "{\"args\":{},\"data\":\"\",\"files\":{\"multi\":\"hey\"},\"form\":{\"hey\":\"there\"}")

    # asynchronous
    println("asynchronous client request body")
    begin
        f = Base.BufferStream()
        write(f, "hey")
        t = @async HTTPA.post("$sch://httpbin.org/post"; body=f, enablechunked=false)
        #fetch(f) # fetch for the async call to write it's first data
        write(f, " there ") # as we write to f, it triggers another chunk to be sent in our async request
        write(f, "sailor")
        close(f) # setting eof on f causes the async request to send a final chunk and return the response
        @test status(fetch(t)) == 200
    end

    # redirects
    println("client redirect following")
    for meth in ("GET","HEAD")
        @test status(HTTPA.request(meth, "$sch://httpbin.org/redirect/1")) ==200
        @test status(HTTPA.request(meth, "$sch://httpbin.org/redirect/1", redirect=false)) == 302
        @test status(HTTPA.request(meth, "$sch://httpbin.org/redirect/6")) == 302 #over max number of redirects
        @test status(HTTPA.request(meth, "$sch://httpbin.org/relative-redirect/1")) == 200
        @test status(HTTPA.request(meth, "$sch://httpbin.org/absolute-redirect/1")) == 200
        @test status(HTTPA.request(meth, "$sch://httpbin.org/redirect-to?url=http%3A%2F%2Fgoogle.com")) == 200
    end


    @test status(HTTPA.post("$sch://httpbin.org/post"; body="√")) == 200
    println("client basic auth")
    @test status(HTTPA.get("$sch://user:pwd@httpbin.org/basic-auth/user/pwd"; basic_authorization=true)) == 200
    @test status(HTTPA.get("$sch://user:pwd@httpbin.org/hidden-basic-auth/user/pwd"; basic_authorization=true)) == 200
    @test status(HTTPA.get("$sch://test:%40test@httpbin.org/basic-auth/test/%40test"; basic_authorization=true)) == 200

    r = HTTPA.request("GET", "$sch://httpbin.org/ip")
    @test status(r) == 200

    uri = HTTPA.URI("$sch://httpbin.org/ip")
    r = HTTPA.request("GET", uri)
    @test status(r) == 200
    r = HTTPA.get(uri)
    @test status(r) == 200

    r = HTTPA.request("GET", "$sch://httpbin.org/ip")
    @test status(r) == 200

    uri = HTTPA.URI("$sch://httpbin.org/ip")
    r = HTTPA.request("GET", uri)
    @test status(r) == 200

    r = HTTPA.get("$sch://httpbin.org/image/png")
    @test status(r) == 200

    # ensure we can use AbstractString for requests
    r = HTTPA.get(SubString("http://httpbin.org/ip",1))

    # canonicalizeheaders
    @test status(HTTPA.get("$sch://httpbin.org/ip"; canonicalizeheaders=false)) == 200

end

@testset "openraw client method" begin
    for sch in ("ws", "wss")
        println("openraw client method: $sch")

        @testset "can send and receive a WebSocket frame" begin
            # WebSockets require valid headers.
            headers = Dict(
                "Upgrade" => "websocket",
                "Connection" => "Upgrade",
                "Sec-WebSocket-Key" => "dGhlIHNhbXBsZSBub25jZQ==",
                "Sec-WebSocket-Version" => "13")

            socket, response = HTTPA.openraw("GET", "$sch://echo.websocket.org", headers)

            @test response.status == 101

            # This is an example text frame from RFC 6455, section 5.7. It sends the text "Hello" to the
            # echo server, and so we expect "Hello" back, in an unmasked frame.
            frame = UInt8[0x81, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58]

            write(socket, frame)

            # The frame we expect back looks like `expectedframe`.
            expectedframe = UInt8[0x81, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f]

            # Note the spec for read says:
            #     read(s::IO, nb=typemax(Int))
            # Read at most nb bytes from s, returning a Vector{UInt8} of the bytes read.
            # ... so read will return less than 7 bytes unless we wait first:
            eof(socket)
            actualframe = read(socket, 7)
            @test expectedframe == actualframe

            close(socket)
        end
    end
end

end # @testset "HTTPA.Client"
