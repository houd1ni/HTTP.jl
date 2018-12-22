module ExceptionRequest

export StatusError

import ..Layer, ..request
import ..HTTPA
using ..Messages: iserror

"""
    request(ExceptionLayer, ::URI, ::Request, body) -> HTTPA.Response

Throw a `StatusError` if the request returns an error response status.
"""
abstract type ExceptionLayer{Next <: Layer} <: Layer end
export ExceptionLayer

function request(::Type{ExceptionLayer{Next}}, a...; kw...) where Next

    res = request(Next, a...; kw...)

    if iserror(res)
        throw(StatusError(res.status, res))
    end

    return res
end

"""
The `Response` has a `4xx`, `5xx` or unrecognised status code.

Fields:
 - `status::Int16`, the response status code.
 - `response` the [`HTTPA.Response`](@ref)
"""
struct StatusError <: Exception
    status::Int16
    response::HTTPA.Response
end

end # module ExceptionRequest
