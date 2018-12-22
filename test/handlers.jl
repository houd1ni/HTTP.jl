using Test, HTTPA

import Base.==

==(a::HTTPA.Response,b::HTTPA.Response) = (a.status  == b.status)    &&
                                        (a.version == b.version)   &&
                                        (a.headers == b.headers)   &&
                                        (a.body    == b.body)

@testset "HTTPA.Handler deprecations tests" begin

f = HTTPA.Handlers.RequestHandlerFunction((req) -> HTTPA.Response(200))
@test HTTPA.handle(f, HTTPA.Request()) == HTTPA.Response(200)

r = HTTPA.Router()
@test isempty(r.routes)
@test HTTPA.handle(r, HTTPA.Request()) == HTTPA.Response(404)

HTTPA.register!(r, "/path/to/greatness", f)
req = HTTPA.Request()
req.target = "/path/to/greatness"
@test HTTPA.handle(r, req) == HTTPA.Response(200)

p = "/next/path/to/greatness"
f2 = HTTPA.Handlers.RequestHandlerFunction((req) -> HTTPA.Response(201))
HTTPA.register!(r, p, f2)
req = HTTPA.Request()
req.target = "/next/path/to/greatness"
@test HTTPA.handle(r, req) == HTTPA.Response(201)

r = HTTPA.Router()
HTTPA.register!(r, "GET", "/sget", f)
HTTPA.register!(r, "POST", "/spost", f)
HTTPA.register!(r, "POST", "/tpost", f)
req = HTTPA.Request("GET", "/sget")
@test HTTPA.handle(r, req) == HTTPA.Response(200)
req = HTTPA.Request("POST", "/sget")
@test HTTPA.handle(r, req) == HTTPA.Response(404)
req = HTTPA.Request("GET", "/spost")
@test HTTPA.handle(r, req) == HTTPA.Response(404)
req = HTTPA.Request("POST", "/spost")
@test HTTPA.handle(r, req) == HTTPA.Response(200)
req = HTTPA.Request("GET", "/tpost")
@test HTTPA.handle(r, req) == HTTPA.Response(404)
req = HTTPA.Request("POST", "/tpost")
@test HTTPA.handle(r, req) == HTTPA.Response(200)

r = HTTPA.Router()
HTTPA.register!(r, "/test", f)
HTTPA.register!(r, "/test/*", f2)
f3 = HTTPA.Handlers.RequestHandlerFunction((req) -> HTTPA.Response(202))
HTTPA.register!(r, "/test/sarv/ghotra", f3)
f4 = HTTPA.Handlers.RequestHandlerFunction((req) -> HTTPA.Response(203))
HTTPA.register!(r, "/test/*/ghotra/seven", f4)

req = HTTPA.Request()
req.target = "/test"
@test HTTPA.handle(r, req) == HTTPA.Response(200)

req.target = "/test/sarv"
@test HTTPA.handle(r, req) == HTTPA.Response(201)

req.target = "/test/sarv/ghotra"
@test HTTPA.handle(r, req) == HTTPA.Response(202)

req.target = "/test/sar/ghotra/seven"
@test HTTPA.handle(r, req) == HTTPA.Response(203)

end

@testset "HTTPA.Handler" begin

f = HTTPA.Handlers.RequestHandlerFunction((req) -> HTTPA.Response(200))
@test HTTPA.handle(f, HTTPA.Request()) == HTTPA.Response(200)

r = HTTPA.Router()
@test isempty(r.routes)
@test HTTPA.handle(r, HTTPA.Request()) == HTTPA.Response(404)

HTTPA.@register(r, "/path/to/greatness", f)
req = HTTPA.Request()
req.target = "/path/to/greatness"
@test HTTPA.handle(r, req) == HTTPA.Response(200)

p = "/next/path/to/greatness"
f2 = HTTPA.Handlers.RequestHandlerFunction((req) -> HTTPA.Response(201))
HTTPA.@register(r, p, f2)
req = HTTPA.Request()
req.target = "/next/path/to/greatness"
@test HTTPA.handle(r, req) == HTTPA.Response(201)

r = HTTPA.Router()
HTTPA.@register(r, "GET", "/sget", f)
HTTPA.@register(r, "POST", "/spost", f)
HTTPA.@register(r, "POST", "/tpost", f)
req = HTTPA.Request("GET", "/sget")
@test HTTPA.handle(r, req) == HTTPA.Response(200)
req = HTTPA.Request("POST", "/sget")
@test HTTPA.handle(r, req) == HTTPA.Response(404)
req = HTTPA.Request("GET", "/spost")
@test HTTPA.handle(r, req) == HTTPA.Response(404)
req = HTTPA.Request("POST", "/spost")
@test HTTPA.handle(r, req) == HTTPA.Response(200)
req = HTTPA.Request("GET", "/tpost")
@test HTTPA.handle(r, req) == HTTPA.Response(404)
req = HTTPA.Request("POST", "/tpost")
@test HTTPA.handle(r, req) == HTTPA.Response(200)

r = HTTPA.Router()
HTTPA.@register(r, "/test", f)
HTTPA.@register(r, "/test/*", f2)
f3 = HTTPA.Handlers.RequestHandlerFunction((req) -> HTTPA.Response(202))
HTTPA.@register(r, "/test/sarv/ghotra", f3)
f4 = HTTPA.Handlers.RequestHandlerFunction((req) -> HTTPA.Response(203))
HTTPA.@register(r, "/test/*/ghotra/seven", f4)

req = HTTPA.Request()
req.target = "/test"
@test HTTPA.handle(r, req) == HTTPA.Response(200)

req.target = "/test/sarv"
@test HTTPA.handle(r, req) == HTTPA.Response(201)

req.target = "/test/sarv/ghotra"
@test HTTPA.handle(r, req) == HTTPA.Response(202)

req.target = "/test/sar/ghotra/seven"
@test HTTPA.handle(r, req) == HTTPA.Response(203)

end

module FooRouter
using HTTPA
const r = HTTPA.Router()
f = HTTPA.Handlers.RequestHandlerFunction((req) -> HTTPA.Response(200))
HTTPA.@register(r, "/test", f)

end # module

req = HTTPA.Request()
req.target = "/test"
@test HTTPA.handle(FooRouter.r, req) == HTTPA.Response(200)
