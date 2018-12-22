# Public Interface

## Requests

```@docs
HTTPA.request(::String,::HTTPA.URIs.URI,::Array{Pair{SubString{String},SubString{String}},1},::Any)
HTTPA.open
HTTPA.get
HTTPA.put
HTTPA.post
HTTPA.head
```

Request functions may throw the following exceptions:

```@docs
HTTPA.StatusError
HTTPA.ParseError
HTTPA.IOError
```
```
Sockets.DNSError
```

## URIs

```@docs
HTTPA.URI
HTTPA.URIs.escapeuri
HTTPA.URIs.unescapeuri
HTTPA.URIs.splitpath
Base.isvalid(::HTTPA.URIs.URI)
```


## Cookies

```@docs
HTTPA.Cookie
```


## Utilities

```@docs
HTTPA.sniff
HTTPA.Strings.escapehtml
```

## Server / Handlers

```@docs
HTTPA.listen
HTTPA.serve
HTTPA.Handlers
HTTPA.handle
HTTPA.RequestHandlerFunction
HTTPA.StreamHandlerFunction
HTTPA.Router
HTTPA.@register
```
