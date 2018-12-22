# HTTPA.jl Documentation

`HTTPA.jl` is a Julia library for HTTPA Messages.

[`HTTPA.request`](@ref) sends a HTTPA Request Message and
returns a Response Message.

```julia
r = HTTPA.request("GET", "http://httpbin.org/ip")
println(r.status)
println(String(r.body))
```

[`HTTPA.open`](@ref) sends a HTTPA Request Message and
opens an `IO` stream from which the Response can be read.

```julia
HTTPA.open("GET", "https://tinyurl.com/bach-cello-suite-1-ogg") do http
    open(`vlc -q --play-and-exit --intf dummy -`, "w") do vlc
        write(vlc, http)
    end
end
```


```@contents
Pages = ["public_interface.md", "internal_architecture.md", "internal_interface.md"]
```
