@testset "utils.jl" begin

import HTTPA.Parsers
import HTTPA.URIs

@test HTTPA.Strings.escapehtml("&\"'<>") == "&amp;&quot;&#39;&lt;&gt;"

@test HTTPA.Cookies.isurlchar('\u81')
@test !HTTPA.Cookies.isurlchar('\0')

@test HTTPA.Strings.tocameldash("accept") == "Accept"
@test HTTPA.Strings.tocameldash("Accept") == "Accept"
@test HTTPA.Strings.tocameldash("eXcept-this") == "Except-This"
@test HTTPA.Strings.tocameldash("exCept-This") == "Except-This"
@test HTTPA.Strings.tocameldash("not-valid") == "Not-Valid"
@test HTTPA.Strings.tocameldash("♇") == "♇"
@test HTTPA.Strings.tocameldash("bλ-a") == "Bλ-A"
@test HTTPA.Strings.tocameldash("not fixable") == "Not fixable"
@test HTTPA.Strings.tocameldash("aaaaaaaaaaaaa") == "Aaaaaaaaaaaaa"
@test HTTPA.Strings.tocameldash("conTENT-Length") == "Content-Length"
@test HTTPA.Strings.tocameldash("Sec-WebSocket-Key2") == "Sec-Websocket-Key2"
@test HTTPA.Strings.tocameldash("User-agent") == "User-Agent"
@test HTTPA.Strings.tocameldash("Proxy-authorization") == "Proxy-Authorization"
@test HTTPA.Strings.tocameldash("HOST") == "Host"
@test HTTPA.Strings.tocameldash("ST") == "St"
@test HTTPA.Strings.tocameldash("X-\$PrototypeBI-Version") == "X-\$prototypebi-Version"
@test HTTPA.Strings.tocameldash("DCLK_imp") == "Dclk_imp"


for (bytes, utf8) in (
        (UInt8[], ""),
        (UInt8[0x00], "\0"),
        (UInt8[0x61], "a"),
        (UInt8[0x63, 0x61, 0x66, 0xe9, 0x20, 0x63, 0x72, 0xe8, 0x6d, 0x65], "café crème"),
        (UInt8[0x6e, 0x6f, 0xeb, 0x6c], "noël"),
        # (UInt8[0x6e, 0x6f, 0xeb, 0x6c, 0x20, 0xa4], "noël €"),
        (UInt8[0xc4, 0xc6, 0xe4], "ÄÆä"),
    )
    @test HTTPA.Strings.iso8859_1_to_utf8(bytes) == utf8
end

# using StringEncodings
# println(encode("ÄÆä", "ISO-8859-15"))

end
