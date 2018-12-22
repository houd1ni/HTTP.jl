@testset "Cookies" begin
    c = HTTPA.Cookies.Cookie()
    @test c.name == ""
    @test HTTPA.Cookies.domainmatch(c, "")

    c.path = "/any"
    @test HTTPA.Cookies.pathmatch(c, "/any/path")
    @test !HTTPA.Cookies.pathmatch(c, "/nottherightpath")

    writesetcookietests = [
	(HTTPA.Cookie("cookie-1", "v\$1"), "cookie-1=v\$1"),
	(HTTPA.Cookie("cookie-2", "two", maxage=3600), "cookie-2=two; Max-Age=3600"),
	(HTTPA.Cookie("cookie-3", "three", domain=".example.com"), "cookie-3=three; Domain=example.com"),
	(HTTPA.Cookie("cookie-4", "four", path="/restricted/"), "cookie-4=four; Path=/restricted/"),
	(HTTPA.Cookie("cookie-5", "five", domain="wrong;bad.abc"), "cookie-5=five"),
	(HTTPA.Cookie("cookie-6", "six", domain="bad-.abc"), "cookie-6=six"),
	(HTTPA.Cookie("cookie-7", "seven", domain="127.0.0.1"), "cookie-7=seven; Domain=127.0.0.1"),
	(HTTPA.Cookie("cookie-8", "eight", domain="::1"), "cookie-8=eight"),
	(HTTPA.Cookie("cookie-9", "expiring", expires=HTTPA.Dates.unix2datetime(1257894000)), "cookie-9=expiring; Expires=Tue, 10 Nov 2009 23:00:00 GMT"),
	# According to IETF 6265 Section 5.1.1.5, the year cannot be less than 1601
	(HTTPA.Cookie("cookie-10", "expiring-1601", expires=HTTPA.Dates.DateTime(1601, 1, 1, 1, 1, 1, 1)), "cookie-10=expiring-1601; Expires=Mon, 01 Jan 1601 01:01:01 GMT"),
	(HTTPA.Cookie("cookie-11", "invalid-expiry", expires=HTTPA.Dates.DateTime(1600, 1, 1, 1, 1, 1, 1)), "cookie-11=invalid-expiry"),
	# The "special" cookies have values containing commas or spaces which
	# are disallowed by RFC 6265 but are common in the wild.
	(HTTPA.Cookie("special-1", "a z"), "special-1=a z"),
	(HTTPA.Cookie("special-2", " z"), "special-2=\" z\""),
	(HTTPA.Cookie("special-3", "a "), "special-3=\"a \""),
	(HTTPA.Cookie("special-4", " "), "special-4=\" \""),
	(HTTPA.Cookie("special-5", "a,z"), "special-5=a,z"),
	(HTTPA.Cookie("special-6", ",z"), "special-6=\",z\""),
	(HTTPA.Cookie("special-7", "a,"), "special-7=\"a,\""),
	(HTTPA.Cookie("special-8", ","), "special-8=\",\""),
	(HTTPA.Cookie("empty-value", ""), "empty-value="),
	(HTTPA.Cookie("", ""), ""),
	(HTTPA.Cookie("\t", ""), ""),
]

@testset "String(::Cookie)" begin
    for (cookie, expected) in writesetcookietests
        @test String(cookie, false) == expected
    end

    cookies = [HTTPA.Cookie("cookie-1", "v\$1"),
    		   HTTPA.Cookie("cookie-2", "v\$2"),
    		   HTTPA.Cookie("cookie-3", "v\$3"),
    		  ]
    @test string("", cookies) == "cookie-1=v\$1; cookie-2=v\$2; cookie-3=v\$3"
end

@testset "readsetcookies" begin
    cookietests = [
        (Dict(["Set-Cookie"=> "Cookie-1=v\$1"]), [HTTPA.Cookie("Cookie-1", "v\$1")]),
        (Dict(["Set-Cookie"=> "NID=99=YsDT5i3E-CXax-; expires=Wed, 23-Nov-2011 01:05:03 GMT; path=/; domain=.google.ch; HttpOnly"]),
            [HTTPA.Cookie("NID", "99=YsDT5i3E-CXax-"; path="/", domain="google.ch", httponly=true, expires=HTTPA.Dates.DateTime(2011, 11, 23, 1, 5, 3, 0))]),
        (Dict(["Set-Cookie"=> ".ASPXAUTH=7E3AA; expires=Wed, 07-Mar-2012 14:25:06 GMT; path=/; HttpOnly"]),
            [HTTPA.Cookie(".ASPXAUTH", "7E3AA"; path="/", expires=HTTPA.Dates.DateTime(2012, 3, 7, 14, 25, 6, 0), httponly=true)]),
        (Dict(["Set-Cookie"=> "ASP.NET_SessionId=foo; path=/; HttpOnly"]),
            [HTTPA.Cookie("ASP.NET_SessionId", "foo"; path="/", httponly=true)]),
        (Dict(["Set-Cookie"=> "special-1=a z"]),  [HTTPA.Cookie("special-1", "a z")]),
        (Dict(["Set-Cookie"=> "special-2=\" z\""]), [HTTPA.Cookie("special-2", " z")]),
        (Dict(["Set-Cookie"=> "special-3=\"a \""]), [HTTPA.Cookie("special-3", "a ")]),
        (Dict(["Set-Cookie"=> "special-4=\" \""]),  [HTTPA.Cookie("special-4", " ")]),
        (Dict(["Set-Cookie"=> "special-5=a,z"]),  [HTTPA.Cookie("special-5", "a,z")]),
        (Dict(["Set-Cookie"=> "special-6=\",z\""]), [HTTPA.Cookie("special-6", ",z")]),
        (Dict(["Set-Cookie"=> "special-7=a,"]),   [HTTPA.Cookie("special-7", "a,")]),
        (Dict(["Set-Cookie"=> "special-8=\",\""]),  [HTTPA.Cookie("special-8", ",")]),
    ]

    for (h, c) in cookietests
        @test HTTPA.Cookies.readsetcookies("", [Dict(h)["Set-Cookie"]]) == c
    end
end

@testset "SetCookieDoubleQuotes" begin
    cookiestrings = [
        "quoted0=none; max-age=30",
        "quoted1=\"cookieValue\"; max-age=31",
        "quoted2=cookieAV; max-age=\"32\"",
        "quoted3=\"both\"; max-age=\"33\"",
    ]
    want = [
        HTTPA.Cookie("quoted0", "none", maxage=30),
        HTTPA.Cookie("quoted1", "cookieValue", maxage=31),
        HTTPA.Cookie("quoted2", "cookieAV"),
        HTTPA.Cookie("quoted3", "both"),
    ]
    @test all(HTTPA.Cookies.readsetcookies("", cookiestrings) .== want)
end

@testset "Cookie sanitize value" begin
    values = Dict(
        "foo" => "foo",
        "foo;bar" => "foobar",
        "foo\\bar" => "foobar",
        "foo\"bar" => "foobar",
        String(UInt8[0x00, 0x7e, 0x7f, 0x80]) => String(UInt8[0x7e]),
        "\"withquotes\"" => "withquotes",
        "a z" => "a z",
        " z" => "\" z\"",
        "a " => "\"a \"",
    )
    for (k, v) in values
        @test HTTPA.Cookies.sanitizeCookieValue(k) == v
    end
end

@testset "Cookie sanitize path" begin
    paths = Dict(
        "/path" => "/path",
        "/path with space/" => "/path with space/",
        "/just;no;semicolon\0orstuff/" => "/justnosemicolonorstuff/",
    )
    for (k, v) in paths
        @test HTTPA.Cookies.sanitizeCookiePath(k) == v
    end
end

@testset "HTTPA.readcookies" begin
    testcookies = [
        (Dict("Cookie" => "Cookie-1=v\$1; c2=v2"), "", [HTTPA.Cookie("Cookie-1", "v\$1"), HTTPA.Cookie("c2", "v2")]),
        (Dict("Cookie" => "Cookie-1=v\$1; c2=v2"), "c2", [HTTPA.Cookie("c2", "v2")]),
        (Dict("Cookie" => "Cookie-1=v\$1; c2=v2"), "", [HTTPA.Cookie("Cookie-1", "v\$1"), HTTPA.Cookie("c2", "v2")]),
        (Dict("Cookie" => "Cookie-1=v\$1; c2=v2"), "c2", [HTTPA.Cookie("c2", "v2")]),
        (Dict("Cookie" => "Cookie-1=\"v\$1\"; c2=\"v2\""), "", [HTTPA.Cookie("Cookie-1", "v\$1"), HTTPA.Cookie("c2", "v2")]),
    ]
    for (h, filter, cookies) in testcookies
        @test HTTPA.Cookies.readcookies(h, filter) == cookies
    end
end
end; # @testset "Cookies"
