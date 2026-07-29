// SPDX-License-Identifier: PMPL-2.0-or-later
const std = @import("std");

pub const AuthorityGrade = enum(u8) {
    formal_primary,
    formal_professional,
    official_guidance,
    prospective,
    secondary_commentary,
};

pub const ReviewState = enum(u8) {
    observed,
    retrieved,
    source_verified,
    parsed,
    diffed,
    machine_classified,
    triage_required,
    impact_candidate_prepared,
    first_review_completed,
    second_review_completed,
    approved,
    tested,
    signed,
    published,
    consumed,
    no_substantive_change,
    rejected,
    needs_specialist_advice,
    awaiting_commencement,
    awaiting_appeal,
    awaiting_external_clarification,
    source_disputed,
    withdrawn,
    revoked_after_publication,
};

pub const Freshness = enum(u8) {
    current_verified,
    current_provisional,
    review_pending,
    change_detected,
    stale,
    source_unavailable,
    superseded,
    revoked,
    unsupported,
};

pub const TemporalFacts = struct {
    publication_date: ?i64 = null,
    made_date: ?i64 = null,
    laid_date: ?i64 = null,
    enactment_date: ?i64 = null,
    royal_assent_date: ?i64 = null,
    commencement_date: ?i64 = null,
    effective_from: ?i64 = null,
    effective_until: ?i64 = null,
    revision_publication_date: ?i64 = null,
    guidance_issued_date: ?i64 = null,
    guidance_withdrawn_date: ?i64 = null,
    consultation_open_date: ?i64 = null,
    consultation_close_date: ?i64 = null,
    judgment_date: ?i64 = null,
    appeal_status_date: ?i64 = null,
    observation_date: i64,
    review_date: ?i64 = null,
    approval_date: ?i64 = null,
    release_date: ?i64 = null,
};

pub const Observation = struct {
    schema_version: u16 = 1,
    source_id: []const u8,
    canonical_uri: []const u8,
    retrieved_uri: []const u8,
    retrieved_at: i64,
    http_status: u16,
    content_type: []const u8,
    raw_digest: [32]u8,
    parser_version: []const u8,
    normaliser_version: []const u8,
    licence_id: []const u8,
    previous_digest: ?[32]u8 = null,
};

pub const BundleGate = struct {
    review_state: ReviewState,
    freshness: Freshness,
    has_signature: bool,
    signature_trusted: bool,
    tests_passed: bool,
    compatibility_declared: bool,
    effective_dates_explicit: bool,
    rollback_safe: bool,
    revoked: bool,
};

pub fn digest(bytes: []const u8) [32]u8 {
    var out: [32]u8 = undefined;
    std.crypto.hash.sha2.Sha256.hash(bytes, &out, .{});
    return out;
}

pub fn canAdvance(from: ReviewState, to: ReviewState) bool {
    return switch (from) {
        .observed => to == .retrieved,
        .retrieved => to == .source_verified,
        .source_verified => to == .parsed,
        .parsed => to == .diffed,
        .diffed => to == .machine_classified,
        .machine_classified => to == .triage_required,
        .triage_required => to == .impact_candidate_prepared,
        .impact_candidate_prepared => to == .first_review_completed,
        .first_review_completed => to == .second_review_completed,
        .second_review_completed => to == .approved,
        .approved => to == .tested,
        .tested => to == .signed,
        .signed => to == .published,
        .published => to == .consumed or to == .revoked_after_publication,
        else => false,
    };
}

pub fn canActivate(gate: BundleGate) bool {
    const review_allows = gate.review_state == .signed or
        gate.review_state == .published;
    const freshness_allows = gate.freshness == .current_verified or
        gate.freshness == .current_provisional;
    return review_allows and
        freshness_allows and
        gate.has_signature and
        gate.signature_trusted and
        gate.tests_passed and
        gate.compatibility_declared and
        gate.effective_dates_explicit and
        gate.rollback_safe and
        !gate.revoked;
}

test "raw digest changes on any byte change" {
    const first = digest("official source");
    const second = digest("official source.");
    try std.testing.expect(!std.mem.eql(u8, &first, &second));
}

test "review states cannot be skipped" {
    try std.testing.expect(canAdvance(.observed, .retrieved));
    try std.testing.expect(!canAdvance(.observed, .parsed));
    try std.testing.expect(!canAdvance(.first_review_completed, .approved));
}

test "unsigned bundle cannot activate" {
    const gate = BundleGate{
        .review_state = .signed,
        .freshness = .current_verified,
        .has_signature = false,
        .signature_trusted = true,
        .tests_passed = true,
        .compatibility_declared = true,
        .effective_dates_explicit = true,
        .rollback_safe = true,
        .revoked = false,
    };
    try std.testing.expect(!canActivate(gate));
}

test "revoked bundle cannot activate" {
    const gate = BundleGate{
        .review_state = .published,
        .freshness = .current_verified,
        .has_signature = true,
        .signature_trusted = true,
        .tests_passed = true,
        .compatibility_declared = true,
        .effective_dates_explicit = true,
        .rollback_safe = true,
        .revoked = true,
    };
    try std.testing.expect(!canActivate(gate));
}

test "publication date does not infer effective date" {
    const temporal = TemporalFacts{
        .publication_date = 1_700_000_000,
        .observation_date = 1_700_000_100,
    };
    try std.testing.expect(temporal.effective_from == null);
}
