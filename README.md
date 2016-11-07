# languamunity
A command-line user-end program for the LanguaMunity system

# Some Surface-Level Subcommands

## git

    languamunity git [localname] [url]

Initializes a new local taking of the course who's GIT bare-repository
is at _\[url\]_, giving it the local-name _\[localname\]_.

It then sets the newly created course-taking as the Standing Default for
the current Languamunity user.

## reinit

    languamunity reinit [localname]

Completely re-initializes the already-existing course-taking
who's local name is _\[localname\]_.

Remember - this means that any lesson that previously was on
your belt will now need to be re-added.

After reinitializing the course-taking,
this command sets the newly reinitialized
course-taking as the Standing Default for
the current Languamunity user.

## select

    languamunity select [localname]

This command simply selects the house named _\[localname\]_
as the Standing Default.

This requires a pre-existing house for that purpose.
(See __languamunity git__ to learn how to create one.)

## eligible

    languamunity eligible

Lists the lessons (by lesson code-ID) that
can be added next time the current Languamunity
user adds a lesson to the belt of the current
Standing Default.

## onbelt

    languamunity onbelt

Lists the lessons (and display by lesson code-ID) that
are currently on the Standing Default house's belt.

They are listed in order of when they were either added
(if they haven't been re-added since) or last re-added
(if they have been) - from earliest to most recent.

## quiz

    languamunity quiz

Begin a five-minute flashcard session.

## houses

    languamunity houses

Lists the "houses" that the current Languamunity user
has on their account.
(A "house" is a term sometimes used to refer to a local
taking of a remote course.)

    languamunity houses -v

This version of the command will also
(in addition to the house's symbolic name) display the
data-source type of each house (even though __git__ is presently
the only possibility) as well as the data-source
location.

## addlcn

    languamunity addlcn [lcnid]

Adds to the belt the lesson who's lesson ID-code is _\[lcnid\]_.

## update

    languamunity update

Updates the contents of the course on the current
House.
All old flash-cards (including any pending rehashes
of previously-missed cards) will be cleared away
to avoid potential conflicts with the updated
course - but the lessons on the belt will remain
listed and therefore do not need to be re-added.

For this recent - excessively frequent updates
of the course content (such as every day or every
few days) are not recommended
(except in _some_ situations involving members
of the team that is actually _developing_ the course)
as excessively frequent purging of the rehash cards
could interfere with the learning process.

On the other hand - you should _NEVER_ let a house
go for _five weeks_ without a content update.
This is because, in addition to each update possibly
bringing more content and/or improvements to old
content, there can also be changes in the
course mapping - and you want to make sure that
the old version of the content that you have (before
the update) is recent enough that the current version
will be able to update the house to accommodate
any changes that have been made.
For this reason, the LanguaMunity project sets
five weeks as the standard amount of time that
should serve as a maximun time between updates.
(This way, if you update every month on the same
day of the month, you should never exceed this
five-week limit.)

Should you make the mistake of allowing more
than five weeks to elapse between updates,
one of the two following possibilities will
occur:

  * You get lucky and, despite your delinquency
your house is still successfully updated
to fit the new course-mapping.
(The more narrowly you miss the five-week
deadline, the more likely it is that you
will be this lucky.)

  * You are not so lucky - and in order to get
the course working properly again, you have
to reinitialize it.
(See the section on the __reinit__ subcommand
to learn how to do this.)

## purge

    languamunity purge [localname]

Completely removes from your account the house
who's local name is _\[localname\]_.


