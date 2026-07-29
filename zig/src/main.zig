// SPDX-License-Identifier: PMPL-2.0-or-later
const std = @import("std");
const authority = @import("authority_watch");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const command = if (args.len > 1) args[1] else "status";

    if (std.mem.eql(u8, command, "status")) {
        showStatus();
        return;
    }
    if (std.mem.eql(u8, command, "freshness")) {
        const profile = if (args.len > 2) args[2] else "uk-insolvency";
        showFreshness(profile);
        return;
    }
    if (std.mem.eql(u8, command, "ingest")) {
        if (args.len != 3) {
            std.debug.print("Use: authority-watch ingest <official-source-file>\n", .{});
            std.process.exit(2);
        }
        try ingest(init, args[2]);
        return;
    }

    std.debug.print(
        "Unknown command: {s}\nUse: status | freshness [profile] | ingest <official-source-file>\n",
        .{command},
    );
    std.process.exit(2);
}

fn showStatus() void {
    std.debug.print(
        \\Authority Watch — offline manual precision core
        \\
        \\SAFETY: observation is not interpretation; interpretation is not approval.
        \\Profile: uk-insolvency (declared, legally unreviewed)
        \\Freshness: UNSUPPORTED
        \\Production trust root: not configured
        \\Automated acquisition: disabled
        \\Unified Hexadeca API: capability blocked
        \\Gossamer console: integration pending
        \\
        \\Manual ingestion can hash an official file without approving or publishing it.
        \\
    , .{});
}

fn showFreshness(profile: []const u8) void {
    std.debug.print(
        "{s}: UNSUPPORTED — no professionally reviewed rule pack or active source-health ledger\n",
        .{profile},
    );
}

fn ingest(init: std.process.Init, path: []const u8) !void {
    const content = try std.Io.Dir.cwd().readFileAlloc(
        init.io,
        path,
        init.arena.allocator(),
        .limited(128 * 1024 * 1024),
    );
    const raw_digest = authority.digest(content);
    const digest_hex = std.fmt.bytesToHex(raw_digest, .lower);
    std.debug.print(
        \\MANUAL OBSERVATION CANDIDATE — NOT AN AUTHORITATIVE RULE
        \\source-file = "{s}"
        \\byte-length = {d}
        \\sha256 = "{s}"
        \\next-state = "operator must supply publisher, official origin, canonical URI, licence and publication status"
        \\
    , .{ path, content.len, &digest_hex });
}
