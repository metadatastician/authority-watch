-- SPDX-License-Identifier: PMPL-2.0-or-later
module AuthorityWatch.Core

import Data.Nat

%default total

public export
record StableId where
  constructor MkStableId
  namespaceName : String
  value : String

public export
data AuthorityGrade
  = FormalPrimary
  | FormalProfessional
  | OfficialGuidance
  | Prospective
  | SecondaryCommentary

public export
record TemporalFacts where
  constructor MkTemporalFacts
  publicationDate : Maybe String
  effectiveFrom : Maybe String
  effectiveUntil : Maybe String
  commencementDate : Maybe String
  observationDate : String
  reviewDate : Maybe String
  approvalDate : Maybe String
  releaseDate : Maybe String

public export
record SourceIdentity where
  constructor MkSourceIdentity
  sourceId : StableId
  publisher : String
  jurisdiction : String
  grade : AuthorityGrade
  officialUri : String

public export
record ObservationIdentity where
  constructor MkObservationIdentity
  observationId : StableId
  source : SourceIdentity
  rawDigest : String
  previousObservation : Maybe StableId

public export
data Freshness
  = CurrentVerified
  | CurrentProvisional
  | ReviewPending
  | ChangeDetected
  | Stale
  | SourceUnavailable
  | Superseded
  | Revoked
  | Unsupported
