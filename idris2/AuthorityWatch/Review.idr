-- SPDX-License-Identifier: PMPL-2.0-or-later
module AuthorityWatch.Review

import AuthorityWatch.Core

%default total

public export
data ReviewState
  = Observed
  | Retrieved
  | SourceVerified
  | Parsed
  | Diffed
  | MachineClassified
  | TriageRequired
  | ImpactCandidatePrepared
  | FirstReviewCompleted
  | SecondReviewCompleted
  | Approved
  | Tested
  | Signed
  | Published
  | Consumed
  | RevokedAfterPublication

public export
data CanAdvance : ReviewState -> ReviewState -> Type where
  ObserveRetrieve : CanAdvance Observed Retrieved
  RetrieveVerify : CanAdvance Retrieved SourceVerified
  VerifyParse : CanAdvance SourceVerified Parsed
  ParseDiff : CanAdvance Parsed Diffed
  DiffClassify : CanAdvance Diffed MachineClassified
  ClassifyTriage : CanAdvance MachineClassified TriageRequired
  TriageImpact : CanAdvance TriageRequired ImpactCandidatePrepared
  ImpactFirstReview : CanAdvance ImpactCandidatePrepared FirstReviewCompleted
  FirstSecondReview : CanAdvance FirstReviewCompleted SecondReviewCompleted
  SecondApprove : CanAdvance SecondReviewCompleted Approved
  ApproveTest : CanAdvance Approved Tested
  TestSign : CanAdvance Tested Signed
  SignPublish : CanAdvance Signed Published
  PublishConsume : CanAdvance Published Consumed
  PublishRevoke : CanAdvance Published RevokedAfterPublication

public export
data ReviewEvidence
  = TwoPersonReview String String
  | ProvisionalSingleReview String

public export
data PublicationClass
  = Production
  | ProvisionalSingleReviewOnly

public export
publicationClass : ReviewEvidence -> PublicationClass
publicationClass (TwoPersonReview _ _) = Production
publicationClass (ProvisionalSingleReview _) = ProvisionalSingleReviewOnly

public export
data ActivationProof
  = Activatable ReviewEvidence

public export
activate : (evidence : ReviewEvidence) -> ActivationProof
activate evidence = Activatable evidence
