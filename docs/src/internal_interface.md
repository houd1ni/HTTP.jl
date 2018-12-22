# Internal Interfaces

## Parser Interface

```@docs
HTTPA.Parsers.find_end_of_header
HTTPA.Parsers.find_end_of_line
HTTPA.Parsers.find_end_of_trailer
HTTPA.Parsers.parse_status_line!
HTTPA.Parsers.parse_request_line!
HTTPA.Parsers.parse_header_field
HTTPA.Parsers.parse_chunk_size
```

## Messages Interface

```@docs
HTTPA.Messages.Request
HTTPA.Messages.Response
HTTPA.Messages.iserror
HTTPA.Messages.isredirect
HTTPA.Messages.ischunked
HTTPA.Messages.issafe
HTTPA.Messages.isidempotent
HTTPA.Messages.header
HTTPA.Messages.hasheader
HTTPA.Messages.setheader
HTTPA.Messages.defaultheader
HTTPA.Messages.appendheader
HTTPA.Messages.readheaders
HTTPA.MessageRequest.setuseragent!
HTTPA.Messages.readchunksize
HTTPA.Messages.headerscomplete(::HTTPA.Messages.Response)
HTTPA.Messages.writestartline
HTTPA.Messages.writeheaders
Base.write(::IO,::HTTPA.Messages.Message)
```

## IOExtras Interface

```@docs
HTTPA.IOExtras
HTTPA.IOExtras.unread!
HTTPA.IOExtras.startwrite(::IO)
HTTPA.IOExtras.isioerror
```


## Streams Interface

```@docs
HTTPA.Streams.closebody
HTTPA.Streams.isaborted
```


## Connection Pooling Interface

```@docs
HTTPA.ConnectionPool.Connection
HTTPA.ConnectionPool.Transaction
HTTPA.ConnectionPool.pool
HTTPA.ConnectionPool.getconnection
HTTPA.IOExtras.unread!(::HTTPA.ConnectionPool.Transaction,::SubArray{UInt8,1,Array{UInt8,1},Tuple{UnitRange{Int64}},true})
HTTPA.IOExtras.startwrite(::HTTPA.ConnectionPool.Transaction)
HTTPA.IOExtras.closewrite(::HTTPA.ConnectionPool.Transaction)
HTTPA.IOExtras.startread(::HTTPA.ConnectionPool.Transaction)
HTTPA.IOExtras.closeread(::HTTPA.ConnectionPool.Transaction)
```
