local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

local tc_default_branch_protection_rule(pattern) =
  orgs.newBranchProtectionRule(pattern) {
        dismisses_stale_reviews: true,
          is_admin_enforced: true,
          required_approving_review_count: 1,
          requires_status_checks: false,
          requires_strict_status_checks: true,
  };

orgs.newOrg('eclipse-tracecompass') {
  settings+: {
    dependabot_security_updates_enabled_for_new_repositories: false,
    description: "",
    name: "Eclipse Trace Compass",
    web_commit_signoff_required: false,
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
      default_workflow_permissions: "write",
    },
  },
  secrets+: [
    orgs.newOrgSecret('ORG_GPG_PASSPHRASE') {
      value: "pass:bots/tools.tracecompass/gpg/passphrase",
    },
    orgs.newOrgSecret('ORG_GPG_PRIVATE_KEY') {
      value: "pass:bots/tools.tracecompass/gpg/secret-subkeys.asc",
    },
    orgs.newOrgSecret('ORG_OSSRH_PASSWORD') {
      value: "pass:bots/tools.tracecompass/oss.sonatype.org/gh-token-password",
    },
    orgs.newOrgSecret('ORG_OSSRH_USERNAME') {
      value: "pass:bots/tools.tracecompass/oss.sonatype.org/gh-token-username",
    },
  ],  
  webhooks+: [
    orgs.newOrgWebhook('https://ci.eclipse.org/tracecompass/github-webhook/') {
      content_type: "json",
      events+: [
        "pull_request",
        "push"
      ],
    },
  ],
  _repositories+:: [
    orgs.newRepo('org.eclipse.tracecompass') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      description: "Eclipse Trace Compass",
      homepage: "https://eclipse.dev/tracecompass/",
      secret_scanning: "disabled",
      secret_scanning_push_protection: "disabled",
      topics+: [
        "profiling",
        "trace-compass",
        "trace",
        "trace-viewer",
        "trace-visualization"
      ],
      web_commit_signoff_required: false,
      workflows+: {
        default_workflow_permissions: "write",
      },
      branch_protection_rules: [
        tc_default_branch_protection_rule('master')
      ],
    },
    orgs.newRepo('trace-event-logger') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "main",
      delete_branch_on_merge: false,
      secret_scanning: "disabled",
      secret_scanning_push_protection: "disabled",
      web_commit_signoff_required: false,
      workflows+: {
        default_workflow_permissions: "read",
      },
      branch_protection_rules: [
        tc_default_branch_protection_rule('main')
      ],
    },
    orgs.newRepo('tracecompass-infra') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      secret_scanning: "disabled",
      secret_scanning_push_protection: "disabled",
      web_commit_signoff_required: false,
      workflows+: {
        enabled: false,
      },
    },
    orgs.newRepo('tracecompass-test-traces') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      secret_scanning: "disabled",
      secret_scanning_push_protection: "disabled",
      web_commit_signoff_required: false,
      workflows+: {
        default_workflow_permissions: "write",
      },
      branch_protection_rules: [
        tc_default_branch_protection_rule('master')
      ],
    },
    orgs.newRepo('tracecompass-website') {
      allow_merge_commit: false,
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      secret_scanning: "disabled",
      secret_scanning_push_protection: "disabled",
      web_commit_signoff_required: false,
      workflows+: {
        default_workflow_permissions: "write",
      },
      branch_protection_rules: [
        tc_default_branch_protection_rule('master')
      ],
    },
  ],
}
