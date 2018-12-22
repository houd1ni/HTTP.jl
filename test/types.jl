@testset "types.jl" begin

@test HTTPA.schemetype(HTTPA.Sockets.TCPSocket) == HTTPA.http
@test HTTPA.schemetype(HTTPA.TLS.SSLContext) == HTTPA.https

@test HTTPA.not(nothing)
@test !HTTPA.not(1)

@test HTTPA.status(HTTPA.Response(300)) == 300
@test String(HTTPA.body(HTTPA.Response("hello world"))) == "hello world"
@test HTTPA.status(HTTPA.Response(300, HTTPA.Headers(), "")) == 300

@test HTTPA.Response(200) == HTTPA.Response(200)

@test string(HTTPA.Response(200)) == "HTTPA/1.1 200 OK\r\nContent-Length: 0\r\n\r\n"

io = IOBuffer()
showcompact(io, HTTPA.Response(200))
@test String(take!(io)) == "Response(200 OK, 0 headers, 0 bytes in body)"

@test string(HTTPA.Request()) == "GET / HTTPA/1.1\r\n\r\n"

showcompact(io, HTTPA.Request())
@test String(take!(io)) == "Request(\"\", 0 headers, 0 bytes in body)"

end
