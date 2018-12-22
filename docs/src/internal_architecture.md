# Internal Architecture

```@docs
HTTPA.Layer
HTTPA.stack
```


## Request Execution Layers

```@docs
HTTPA.RedirectLayer
HTTPA.BasicAuthLayer
HTTPA.CookieLayer
HTTPA.CanonicalizeLayer
HTTPA.MessageLayer
HTTPA.AWS4AuthLayer
HTTPA.RetryLayer
HTTPA.ExceptionLayer
HTTPA.ConnectionPoolLayer
HTTPA.TimeoutLayer
HTTPA.StreamLayer
```

## Parser

*Source: `Parsers.jl`*

```@docs
HTTPA.Parsers
```


## Messages
*Source: `Messages.jl`*

```@docs
HTTPA.Messages
```


## Streams
*Source: `Streams.jl`*

```@docs
HTTPA.Streams.Stream
```


## Connections

*Source: `ConnectionPool.jl`*

```@docs
HTTPA.ConnectionPool
```
