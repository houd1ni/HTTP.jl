[33mcommit 5a789d452dda9e07481b44a548433163460ac401[m[33m ([m[1;36mHEAD -> [m[1;32mmaster[m[33m, [m[1;31morigin/master[m[33m, [m[1;31morigin/HEAD[m[33m)[m
Author: Michael <pinke@live.ru>
Date:   Sat Dec 22 14:03:57 2018 +0300

    project

[33mcommit 25e5ad555dc664f6131ba8cda9c023a19670327a[m
Author: Michael <pinke@live.ru>
Date:   Sat Dec 22 14:03:29 2018 +0300

    rename all

[33mcommit b5005cab55c580a8406b8b65d517e49cb108762c[m
Author: Michael <pinke@live.ru>
Date:   Sat Dec 22 13:59:19 2018 +0300

    project

[33mcommit d79513cf0ea68da05890cb0532eea9186ee7bdc5[m
Author: Michael <pinke@live.ru>
Date:   Sat Dec 22 13:53:58 2018 +0300

    manifest

[33mcommit f8985b0169447d439ba705e7087a22f87b2f3d30[m
Author: Michael <pinke@live.ru>
Date:   Sat Dec 22 13:42:44 2018 +0300

    manifest

[33mcommit b2125764fcdc061529218c7f7e186433ae9a0a58[m
Author: Michael <pinke@live.ru>
Date:   Sat Dec 22 13:24:16 2018 +0300

    rename

[33mcommit ae3bde2dd9f1d46eae8bde00227cf2093b918824[m
Author: Michael <pinke@live.ru>
Date:   Sat Dec 22 13:19:50 2018 +0300

    patch

[33mcommit a916dd1219367903f84af56c014c0c2a83ccf694[m
Merge: a383583 e0fbc89
Author: Sam O'Connor <sam@octech.com.au>
Date:   Wed Dec 19 08:51:42 2018 +1100

    Merge pull request #346 from JuliaWeb/issue_344
    
    fix #344 and #343

[33mcommit a38358367af3b0b5ae185583af6c2a594245acb2[m
Merge: 0fec7d0 f28f47c
Author: Sam O'Connor <sam@octech.com.au>
Date:   Wed Dec 19 08:51:14 2018 +1100

    Merge pull request #338 from JuliaWeb/so/streamio
    
    Improve streaming interface. Reduce allocation and buffering.

[33mcommit 0fec7d0f3f16a081adead9a9619dacba48328463[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Mon Dec 17 14:14:04 2018 -0800

    Exclude Content-Length from AWS4 signing (#368)
    
    This is done in Amazon's examples but does not appear to be addressed in
    the documentation, so we'll just follow suit with the example.

[33mcommit 5dc05565a58ca1f06fbbc276d74cbecd5a7f4471[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Mon Dec 17 12:45:50 2018 -0800

    AWS4: Escape S3 paths and add tests (#369)
    
    The documentation says that the paths for S3 requests should be escaped,
    but currently we're neither escaping nor normalizing them. Per text
    included in the AWS4 test suite, we'll continue not to normalize them,
    but we should be escaping.

[33mcommit 3e029d282f9091a01904a87aee983d74f6ec8d52[m
Merge: 0d3f760 e47241f
Author: Alex Arslan <ararslan@comcast.net>
Date:   Fri Dec 14 13:22:41 2018 -0800

    Merge pull request #366 from JuliaWeb/aa/aws4-post
    
     Add option to exclude the session token from signing

[33mcommit e47241fe611dffa51edcf69c5fb2ce590cc26a03[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Thu Dec 13 14:21:59 2018 -0800

    Add option to exclude the session token from signing
    
    Some AWS services want it in the signature and some do not, so this
    provides the option to include it, defaulting to yes (so no change from
    the current behavior). The header with the security token is always
    included if available.

[33mcommit a9eb78f7a8947f9b6cf5c268645d260322f02337[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Thu Dec 13 14:09:36 2018 -0800

    Add tests for AWS4 POST requests

[33mcommit 0d3f7604d55989615533904024866d0cad2270a3[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Thu Dec 13 13:21:34 2018 -0800

    Add a comment about AWS4/RFC discrepancy for ~ escaping (#365)
    
    [ci skip]

[33mcommit 9964bc7faad73f09bc6669f7976e338a4c4bccc4[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Thu Dec 13 12:59:21 2018 -0800

    Fix and test path normalization for AWS4 signing (#364)

[33mcommit 209a2d36c14c0972a6ada09d5bf5e2410b116294[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Wed Dec 12 17:03:51 2018 -0800

    Fix and test edge cases in handling of AWS4 headers (#359)
    
    In particular, we were not correctly handling duplicate and multiline
    headers.

[33mcommit ad59dd580932688e7047a7ee226791e274b91f5f[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Tue Dec 11 10:47:16 2018 -0800

    Add URI path normalization (#363)
    
    In particular, removal of dot segments per RFC 3986, section 5.2.4.

[33mcommit 2502aaa18c711374fa12dfa14f300f289feecd32[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Tue Dec 4 12:50:31 2018 -0800

    Add a few basic tests from Amazon's test suite
    
    This adds 3 cases that currently pass based on Amazon's test suite:
    https://docs.aws.amazon.com/general/latest/gr/signature-v4-test-suite.html

[33mcommit d3a7e1750125e797c81bc5cbe94a2ff6322bb042[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Tue Dec 4 14:06:19 2018 -0800

    Make including x-amz-content-sha256 opt-in unless required
    
    The x-amz-content-sha256 header is required for all S3 PUT requests, but
    is otherwise not required. This makes including it optional in cases
    when it isn't required.

[33mcommit 096e4e89e11c32c3a2dad5b5d5b3077363252413[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Tue Dec 4 13:59:07 2018 -0800

    Make including the Content-MD5 header optional
    
    Amazon does not require it but recommends it as an end-to-end integrity
    check. None of their examples use it, so making it optional improves our
    ability to test against the official examples.

[33mcommit c361be7114c65eae7ca2f99b4bdcc33ba7d706ee[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Tue Dec 4 13:56:43 2018 -0800

    Include host in AWS4 requests
    
    This is not required but it matches all of Amazon's own examples and
    test cases.

[33mcommit 15863d49bc21f7e88408be781d6bc46c611d4dd4[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Fri Nov 30 14:24:02 2018 -0800

    AWS4: Replace multiple spaces with one in canonical headers (#353)
    
    As described in the AWS Signature v4 documentation:
    https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
    
    This commit also includes minor, non-functional code simplification.

[33mcommit d54b13b22fa51f522be5533dbfc06255ec9f6aa7[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Thu Nov 29 20:12:17 2018 -0800

    Make DEBUG_LEVEL a Ref{Int} instead of an Int (#354)
    
    This is a quality of life improvement for local use. One can now simply
    write `HTTP.DEBUG_LEVEL[] = 2`, for example, to set the appropriate
    level.

[33mcommit 836edd04dc5194856df77ca66a2b8fb43df1942a[m
Merge: 8408c05 78e8062
Author: Alex Arslan <ararslan@comcast.net>
Date:   Tue Nov 27 14:02:50 2018 -0800

    Merge pull request #351 from fredrikekre/fe/docs
    
    Misc doc updates

[33mcommit 8408c0506f4db6efe4f95f8d24ea4e83001eaa8f[m
Author: Alex Arslan <ararslan@comcast.net>
Date:   Tue Nov 27 12:07:58 2018 -0800

    Deprecate the t kwarg to timestamp in sign_aws4! (#352)

[33mcommit 78e806240f90676934f49bef73048dfaae5594e3[m
Author: Fredrik Ekre <ekrefredrik@gmail.com>
Date:   Sat Nov 17 11:09:26 2018 +0100

    Update README links.

[33mcommit ca13ef3fb0af7f03613350adf28bcbea65ed8a4d[m
Author: Fredrik Ekre <ekrefredrik@gmail.com>
Date:   Sat Nov 17 11:05:40 2018 +0100

    Remove undocumented HTTP.Handler from at-docs block.

[33mcommit 6aae862e189ebe8699a59476f913f40f36177e70[m
Author: Fredrik Ekre <ekrefredrik@gmail.com>
Date:   Fri Nov 16 19:30:37 2018 +0100

    Split up the three sections into three separate pages.

[33mcommit 831fda4389740f4b24202112657f058236b15cb2[m
Author: Fredrik Ekre <ekrefredrik@gmail.com>
Date:   Fri Nov 16 19:27:15 2018 +0100

    Upgrade to Documenter v0.20 (and actually deploy docs).

[33mcommit 804bd7005fa7c2b91123058d0bd15f7fa69a453f[m
Merge: f3437c7 0b17a1b
Author: Sam O'Connor <sam@octech.com.au>
Date:   Fri Nov 9 08:40:51 2018 +1100

    Merge pull request #348 from christopher-dG/cdg/statuscode
    
    Close WebSockets with a status code

[33mcommit f3437c710b86b8924c92a15477ecc20fa73b3a1b[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Fri Nov 9 08:30:01 2018 +1100

    WebSocket Example, See https://github.com/JuliaWeb/MbedTLS.jl/issues/186#issuecomment-435544863

[33mcommit 0b17a1b412198da9cb0899d1b8157c6fbfce962d[m
Author: Chris de Graaf <chrisadegraaf@gmail.com>
Date:   Thu Nov 8 15:29:18 2018 -0600

    Use try/catch instead of strict flag, remove isopen check

[33mcommit e4a133e20e9ee6b4445cafb86193dd490768d228[m
Author: Chris de Graaf <chrisadegraaf@gmail.com>
Date:   Thu Nov 8 09:34:21 2018 -0600

    Don't throw for non-1000 status codes when closing

[33mcommit e220d9bae191c35b18bfa92c29ade34fc1bf3d90[m
Author: Chris de Graaf <chrisadegraaf@gmail.com>
Date:   Fri Nov 2 20:21:54 2018 -0500

    Close WebSockets with a status code

[33mcommit e0fbc89d4428f4733edd2eb6bb05b05e0cc84342[m[33m ([m[1;31morigin/issue_344[m[33m)[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Thu Nov 1 15:43:55 2018 +1100

    fix #343

[33mcommit b6bd9c34d89f883e726d3971c14ba70e8d64c286[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Thu Nov 1 15:08:34 2018 +1100

    fix #344

[33mcommit f28f47cc20e1d92889cf2087c0378ae5eab8fac5[m[33m ([m[1;31morigin/so/streamio[m[33m)[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Thu Nov 1 14:45:04 2018 +1100

    remove FIXME

[33mcommit da4a08b9b5610691bd074442330d05d36cf64fc6[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Thu Oct 25 21:56:54 2018 +1100

    replace global byte_read_warning_done with http.warn_not_to_read_one_byte_at_a_time

[33mcommit 3687e02db3d4902b7e2c4cfd906829bd74bebf2f[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Mon Oct 22 21:55:33 2018 +1100

    improve Base.read(http::Stream), read entire chunk/body at a time where possible

[33mcommit d9f883181defdf4229796a7084611062c2ae1c23[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Mon Oct 22 20:52:40 2018 +1100

    Revise Base.read(http::Stream) to avoid allocation of `readavailable`
    buffers.

[33mcommit d14867f20fe4332ef5b7edb111622862500276a3[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Mon Oct 22 18:26:11 2018 +1100

    Improve byte-by-byte reading.
    
    Split read_to_buffer out of readuntil

[33mcommit bd32b7c1f55fb535e6dc8dd5753669da3f77a994[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Mon Oct 22 17:47:09 2018 +1100

    Remove IOExtras.unread!
    Replace `Connection.excess::ByteView` with `Connection.buffer::IOBuffer`
    Remove `readavailable(::Transaction)` in favour of `unsafe_read` and
    `read`.

[33mcommit c24c39591e8d411f1674d9830076ac63c7d0d787[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Mon Oct 22 14:03:21 2018 +1100

    replace Base.readuntil(::HTTP.Stream,) / IOExtras.unread(::HTTP.Stream,)
    with Base.read(::HTTP.Stream, UInt8) (byte-by-byte read method). This
    allows Base.readline to work in the normal way. The complexity of
    unreading back into the Transaction buffer isn't worth it and won't
    work in all cases anyway (e.g. multi-chunk unread). Add warning to
    suggest `BufferedInputStream` for users who need to read byte-by-byte.

[33mcommit 49cf9dd584e180e6cbec07a0a0633f13e156e93c[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Mon Oct 22 11:39:28 2018 +1100

    call startread on demand in HTTP.Stream read functions

[33mcommit 6414e992924f84e54e2af9cd2adabd1fe6f6fc93[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Mon Oct 22 08:35:17 2018 +1100

    Try to get streaming read sizes to match up with chunk sizes where
    possible.
    
    The IODebug logging for these two cases now has less `unread!`-ing
    and less fragmentation.
    
    ```
    HTTP.open(..., verbose=3) do http
       while !eof(http)
           buf = Vector{UInt8}(undef, 4096)
           @show readbytes!(http, buf)
       end
    end
    
    HTTP.open(..., verbose=3) do http
       while !eof(http)
           readavailable(http)
       end
    end
    ```
    
    Add readuntil_block_size = 4096. Attempt to avoid reading ahead to far
    when looking for end of headers / endof chunksize.
    
    Speculatively try to read and ignore 2 extra bytes in chunked mode.
    Usually the trailing CRLF seems to be in the same packet as the last
    part of the chunk data, so this avoids a follow-up fragmented read
    when parsing the next chunk size. This should have no downside
    for peers that send the trailing CRLF in the same packet as the
    new chunk size as the chunk size parser will still ignore it
    in that case.

[33mcommit 3cbd5d106e11d986530e1ba3a73ef77462003489[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Sun Oct 21 20:59:30 2018 +1100

    Rename find_end_of_line -> find_end_of_chunk_size
    
    Skip leading CRLF in find_end_of_chunk_size and parse_chunk_size
    
    Add chunk_size_line_max limit to protect against malicious chunk size
    lines
    
    Simplify HTTP.Stream.ntoread accounting by not including 2 bytes for
    trailing   CRLF in notread.
    
    Simplify implementation of Base.read* functions.

[33mcommit f43e78d2e51d438d1230ad849b933993d6759ae8[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Sat Oct 20 22:21:43 2018 +1100

    implement Base.unsafe_read(::HTTP.Stream, ...) and Base.read(http::Stream, ...)

[33mcommit df13276971d66a7cd9c54cfb88a5d0000773d419[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Wed Oct 17 02:11:45 2018 +1100

    Cosmetic changes (#330)
    
    Remove redundant `using MbedTLS` from toplevel `src/HTTP.jl`
    
    Servers.jl:
     - Line-wrap some docstrings and code
     - More examples in docstrings.
     - Some refinement of wording and punctuation in docstrings.
     - Avoid bringing unwanted symbols in from MbedTLS (`encrypt` etc).
     - Rename `Server2` -> `Server` and fix up type params.
     - Call `@async check_readtimeout` rather than having `@async while`
       inside that function.
    
    test/server.jl
     - Qualify type names to allow test to run stand-alone.

[33mcommit a262701d439f394327008efa94a5f6331e538a66[m
Author: Fredrik Ekre <fredrik.ekre@chalmers.se>
Date:   Tue Oct 16 16:51:27 2018 +0200

    Use the General registry uuid. (#333)

[33mcommit c24513dbb56663b93a2eee8aa39f085bfd4d949c[m
Merge: 1f40c9c c444c18
Author: Sam O'Connor <sam@octech.com.au>
Date:   Tue Oct 16 12:16:14 2018 +1100

    Merge pull request #301 from JuliaWeb/jq/servers
    
    Refactor HTTP.Servers & HTTP.Handlers

[33mcommit 1f40c9ce795d7c63bb81c09bed53670955ed556a[m
Merge: cf1c081 65ed2f4
Author: Sam O'Connor <sam@octech.com.au>
Date:   Mon Oct 15 21:08:10 2018 +1100

    Merge pull request #282 from erikedin/pr_openraw2
    
    add HTTP.openraw method to get raw socket

[33mcommit cf1c08102c28cb019f8a0b19e2d3e43e22e6786c[m
Merge: 84609dc f3ff2a6
Author: Sam O'Connor <sam@octech.com.au>
Date:   Mon Oct 15 21:03:19 2018 +1100

    Merge pull request #321 from CarpeNecopinum/master
    
    Fixed WebSockets not accepting upgrade requests from Firefox

[33mcommit 65ed2f42b6c0c3f4b8fa6857e8bb72e8d64d1811[m
Author: Erik Edin <erikedin@users.noreply.github.com>
Date:   Sun Oct 14 17:54:05 2018 +0200

    openraw: use Transaction instead of socket

[33mcommit c444c184d8ede3c5e9921a658121ffcdba6f543d[m[33m ([m[1;31morigin/jq/servers[m[33m)[m
Author: quinnj <quinn.jacobd@gmail.com>
Date:   Mon Oct 8 23:10:07 2018 -0600

    Fix tests

[33mcommit ffc01b835fd2e7da89131026fdcd3b68faa1ffd4[m
Author: quinnj <quinn.jacobd@gmail.com>
Date:   Mon Oct 8 22:24:15 2018 -0600

    Fix failing tests

[33mcommit 84609dce61afdb565921db1afc64a38f85577d77[m
Author: Sam O'Connor <sam@octech.com.au>
Date:   Tue Oct 9 10:54:06 2018 +1100

    work in progres timing combinations test
    intended to give TLS eof()/blocking/non-blocking beahiour a work-out

[33mcommit 522bb7aabba3f4c424adbd55ca6bfa3e1a9bef52[m
Author: quinnj <quinn.jacobd@gmail.com>
Date:   Sat Oct 6 21:56:46 2018 -0600

    Reinstate HTTP.serve to do request serve handling

[33mcommit 2edcbb3255e4c573ea96e64ff632a6112b412c1b[m
Author: quinnj <quinn.jacobd@gmail.com>
Date:   Sat Oct 6 16:28:59 2018 -0600

    Address PR feedback

[33mcommit f3ff2a6cb642c825ed291a06141fd29fac67cb91[m
Author: CarpeNecopinum <CarpeNecopinum@users.noreply.github.com>
Date:   Fri Oct 5 10:08:57 2018 +0200

    Added tests for hasheader and headercontains
