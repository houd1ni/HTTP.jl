
# HTTPA

*HTTPA client and server functionality for Julia*

| **Documentation**                                                               | **PackageEvaluator**                                            | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:---------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][pkg-0.6-img]][pkg-0.6-url] | [![][travis-img]][travis-url] [![][appveyor-img]][appveyor-url] [![][codecov-img]][codecov-url] |


## Installation

The package is registered in `METADATA.jl` and so can be installed with `Pkg.add`.
```julia
julia> Pkg.add("HTTPA")
```

<!-- ## Documentation

- [**STABLE**][docs-stable-url] &mdash; **most recently tagged version of the documentation.**
- [**LATEST**][docs-latest-url] &mdash; *in-development version of the documentation.* -->

## Project Status

The package is new and not yet tested in production systems.
Please try it out and report your experience.

The package is tested against Julia 0.6.2 & current master on Linux, macOS, and Windows.

## Contributing and Questions

Contributions are very welcome, as are feature requests and suggestions. Please open an
[issue][issues-url] if you encounter any problems or would just like to ask a question.


## Client Examples

[`HTTPA.request`](https://juliaweb.github.io/HTTPA.jl/stable/index.html#HTTPA.request-Tuple{String,HTTPA.URIs.URI,Array{Pair{SubString{String},SubString{String}},1},Any})
sends a HTTPA Request Message and returns a Response Message.

```julia
r = HTTPA.request("GET", "http://httpbin.org/ip"; verbose=3)
println(r.status)
println(String(r.body))
```

[`HTTPA.open`](https://juliaweb.github.io/HTTPA.jl/stable/index.html#HTTPA.open)
sends a HTTPA Request Message and
opens an `IO` stream from which the Response can be read.

```julia
HTTPA.open("GET", "https://tinyurl.com/bach-cello-suite-1-ogg") do http
    open(`vlc -q --play-and-exit --intf dummy -`, "w") do vlc
        write(vlc, http)
    end
end
```

## Server Examples

[`HTTPA.Servers.listen`](https://juliaweb.github.io/HTTPA.jl/stable/index.html#HTTPA.Servers.listen):

```julia
HTTPA.listen() do http::HTTPA.Stream
    @show http.message
    @show HTTPA.header(http, "Content-Type")
    while !eof(http)
        println("body data: ", String(readavailable(http)))
    end
    setstatus(http, 404)
    setheader(http, "Foo-Header" => "bar")
    startwrite(http)
    write(http, "response body")
    write(http, "more response body")
end
```

[`HTTPA.Handlers.serve`](https://juliaweb.github.io/HTTPA.jl/stable/index.html#HTTPA.Handlers.serve):
```julia
HTTPA.serve() do request::HTTPA.Request
   @show request
   @show request.method
   @show HTTPA.header(request, "Content-Type")
   @show HTTPA.payload(request)
   try
       return HTTPA.Response("Hello")
   catch e
       return HTTPA.Response(404, "Error: $e")
   end
end
```

## WebSocket Examples

```julia
julia> @async HTTPA.WebSockets.listen("127.0.0.1", UInt16(8081)) do ws
           while !eof(ws)
               data = readavailable(ws)
               write(ws, data)
           end
       end

julia> HTTPA.WebSockets.open("ws://127.0.0.1:8081") do ws
           write(ws, "Hello")
           x = readavailable(ws)
           @show x
           println(String(x))
       end;
x = UInt8[0x48, 0x65, 0x6c, 0x6c, 0x6f]
Hello
```

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://JuliaWeb.github.io/HTTPA.jl/dev

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://JuliaWeb.github.io/HTTPA.jl/stable

[travis-img]: https://travis-ci.org/JuliaWeb/HTTPA.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaWeb/HTTPA.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/qdy0vfps9gne3sd7?svg=true
[appveyor-url]: https://ci.appveyor.com/project/quinnj/http-jl

[codecov-img]: https://codecov.io/gh/JuliaWeb/HTTPA.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/JuliaWeb/HTTPA.jl

[issues-url]: https://github.com/JuliaWeb/HTTPA.jl/issues

[pkg-0.6-img]: http://pkg.julialang.org/badges/HTTP_0.6.svg
[pkg-0.6-url]: http://pkg.julialang.org/?pkg=HTTPA
