# ShareCal TestFlight Review Notes

Use this document when moving ShareCal from the rejected public App Store submission to private TestFlight testing.

## Public Submission Cleanup

1. Open App Store Connect > ShareCal > App Review.
2. Open the unresolved iOS submission for version 1.0.
3. Remove the rejected App Version item from the submission instead of resubmitting it for public App Review.
4. Do not use "Resubmit to App Review" for the public listing unless the product direction changes back to public App Store distribution.

## TestFlight Test Information

### Beta App Description

ShareCal is a private shared calendar beta for invited couples. It lets two invited users mirror selected Apple Calendar events into a private iCloud share, view both schedules side by side, send event invitations, and comment on shared events. The beta is intended for invited testers only while we validate the iCloud sharing workflow and calendar privacy controls.

### What to Test

Please test the first-run flow, calendar permission request, selected calendar sync, iCloud share creation, paired schedule view, event invitation acceptance, and comments on shared events. If you do not have a second test device available, open the Calendar tab and tap "Load Sample Schedule" to preview the paired timeline, sample invitation, and sample comment data.

### Feedback Email

Use the same support email configured for the Apple Developer account, or a monitored project inbox for TestFlight feedback.

## Beta App Review Notes

ShareCal is being submitted for private TestFlight beta testing, not for public App Store release. The beta is for invited couples who want to test private iCloud calendar sharing.

Reviewer steps:

1. Install ShareCal from TestFlight on an iPhone signed in to iCloud.
2. Open Settings inside the app.
3. Tap "Request Full Calendar Access" and grant calendar access. If no calendars are available on the review device, continue with step 6.
4. Select one or more calendars under "Calendars to Share".
5. Return to Calendar and tap the sync button in the top-right toolbar.
6. If there are no real calendar events or no second reviewer device, tap "Load Sample Schedule" on the Calendar tab. This creates local preview data for both members, one sample invitation, and one sample comment.
7. Tap an event to inspect details, add a comment, or create an invitation.
8. Open the Invites tab to view and accept or decline the sample invitation.
9. For two-device testing, create an iCloud share from Settings > iCloud Share, accept it on the second device, and repeat the sync/comment/invite flow.

Notes:

- Calendar data is stored locally and in the user's private iCloud/CloudKit share.
- ShareCal does not run its own server and does not include advertising, third-party analytics, or tracking SDKs.
- The in-app sample data is only for review and tester onboarding; it does not upload unless the tester explicitly syncs while using a CloudKit-enabled build.

## 90-Day TestFlight Maintenance

- Upload a new build before the active TestFlight build expires.
- Keep external tester groups limited to invited users.
- Review TestFlight crash reports and feedback weekly while the beta is active.
- Only return to public App Store submission after the app has a stronger public positioning, non-template screenshots, and App Review notes that explain its unique value.
