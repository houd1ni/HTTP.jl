using HTTPA
using HTTPA: hasheader
using MbedTLS

@static if is_apple()
    launch(x) = run(`open $x`)
elseif is_linux()
    launch(x) = run(`xdg-open $x`)
elseif is_windows()
    launch(x) = run(`cmd /C start $x`)
end

@async begin
    sleep(2)
    launch("https://127.0.0.1:8000/examples/mwe")
end

HTTPA.listen("127.0.0.1", 8000;
            sslconfig = MbedTLS.SSLConfig(joinpath(dirname(@__FILE__), "cert.pem"),
                                          joinpath(dirname(@__FILE__), "key.pem"))) do http
    if HTTPA.WebSockets.is_websocket_upgrade(http.message)

        HTTPA.WebSockets.upgrade(http) do client
            count = 1
            while !eof(client);
                msg = String(readavailable(client))
                println(msg)
                write(client, "Hello JavaScript! From Julia $count")
                count += 1
            end
        end
    else
        h = HTTPA.Handlers.RequestHandlerFunction() do req::HTTPA.Request
            HTTPA.Response(200,read(joinpath(dirname(@__FILE__),"mwe.html"), String))
        end
        HTTPA.Handlers.handle(h, http)
    end
end




