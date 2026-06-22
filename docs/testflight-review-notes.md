# OurDays App Review Notes

Reviewer-facing notes for OurDays (bundle `com.leeberty.CoupleCalendar`), covering both the public App Store review and the external TestFlight beta. The app was previously rejected as "ShareCal" under Guideline 4.3(a); it has since been rebranded to OurDays with strengthened positioning and resubmitted to the public App Store.

## Current Submission Status

- Public App Store: v1.3 (build 30) submitted for review as OurDays (the v1.0 "ShareCal" submission was rejected under 4.3(a); product direction has since returned to public App Store distribution). Release type is MANUAL.
- TestFlight: the external public link remains active for invited testers.

## Test Information

### App Description

OurDays is a private shared calendar for invited couples. It lets two invited users mirror selected Apple Calendar events into a private iCloud share, view both schedules side by side, send event invitations, and comment on shared events.

### What to Test

Please test the first-run flow, calendar permission request, selected calendar sync, iCloud share creation, paired schedule view, event invitation acceptance, and comments on shared events. On a single device the side-by-side dual-column schedule shows your own events in the "me" column; the partner column, invitations, and comments require a second iCloud user paired via Settings > iCloud Share. (There is no in-app sample-data button.)

### Feedback Email

Use the same support email configured for the Apple Developer account, or a monitored project inbox for TestFlight feedback.

## Reviewer Notes

These reviewer steps apply to both the public App Store review and the TestFlight beta. No sign-in is required; OurDays is for two invited users who privately share selected calendars.

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
- Keep the public App Store listing's positioning strong: non-template screenshots and review notes that explain the unique two-person value (this is what the v1.0 4.3(a) rejection turned on).
