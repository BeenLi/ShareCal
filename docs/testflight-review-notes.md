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

Please test the first-run flow, calendar permission request, selected calendar sync, iCloud share creation, paired schedule view, event invitation acceptance, and comments on shared events. On a single device the side-by-side dual-column schedule shows your own events in the "me" column; the partner column, invitations, and comments require a second iCloud user paired via Settings > iCloud Share. (There is no in-app sample-data button.)

### Feedback Email

Use the same support email configured for the Apple Developer account, or a monitored project inbox for TestFlight feedback.

## Beta App Review Notes

OurDays is being submitted for private TestFlight beta testing, not for public App Store release. The beta is for invited couples who want to test private iCloud calendar sharing.

Reviewer steps:

1. Install OurDays from TestFlight on an iPhone signed in to iCloud.
2. Open the Settings tab.
3. Tap "Request Full Calendar Access" and grant calendar access.
4. Under "Calendars to Share", select a writable calendar. If the device has no suitable calendar, tap "Create Shared Calendar" to create one, then select it.
5. OurDays only displays events mirrored from the selected calendar(s); it does not create events itself. If that calendar has no events, add one or two in Apple's Calendar app so there is something to show.
6. Open the Calendar tab and tap the sync button in the top-right toolbar. Your events appear in the "me" column of the two-column, side-by-side schedule — the core differentiator. Switch Day/Week and tap an event for details.
7. Invitations and comments are two-person features that require a paired partner (step 8).
8. For two-device testing, create an iCloud share from Settings > iCloud Share, accept it on a second device signed in to a different iCloud account, then repeat the sync/comment/invite flow.

Notes:

- Calendar data is stored locally and in the user's private iCloud/CloudKit share.
- OurDays does not run its own server and does not include advertising, third-party analytics, or tracking SDKs.
- There is no in-app sample/demo data feature; the side-by-side schedule is populated from the reviewer's own selected calendars, and the two-person features require a second iCloud user.

## 90-Day TestFlight Maintenance

- Upload a new build before the active TestFlight build expires.
- Keep external tester groups limited to invited users.
- Review TestFlight crash reports and feedback weekly while the beta is active.
- Only return to public App Store submission after the app has a stronger public positioning, non-template screenshots, and App Review notes that explain its unique value.
