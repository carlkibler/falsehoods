# Falsehoods About Job Applicants

> Your assumptions about applicants and their histories are mostly wrong.

This list comes from someone who is not a programmer but who has spent years filling out job-application forms with an unusual work history — and getting blocked by software that assumed everyone's career looks like a tidy ladder. Many of the falsehoods about [names](#), [genders](#), and addresses apply here too; a job application is just one more form that quietly assumes you're someone you're not.

## The Big Surprises

- **A job isn't always paid.** Internships, volunteer roles, family businesses, and unpaid trial work are all real experience. A form that requires a salary figure or treats "$0" as invalid silently erases a chunk of someone's career.

- **The applicant might be their own manager.** Freelancers, founders, and sole proprietors have no supervisor to list and no boss to call as a reference. "Who was your manager?" has no good answer when the answer is "me."

- **A job isn't always legal.** Sex work, undocumented labor, jobs in jurisdictions where the work is criminalized — people do them, gain real skills, and can't always declare them on a form. Demanding a verifiable, lawful employer for every entry assumes a privilege not everyone has.

- **The company may no longer exist.** Startups fold, firms get acquired and renamed, sole proprietors close shop. Requiring a current phone number for a defunct employer — or a former supervisor who's now unreachable — turns honest history into an error message.

- **The applicant may have had a different name at past jobs.** Marriage, divorce, transition, legal changes — the name on a five-year-old payslip may not match the name on today's application. Forms that demand identical names across all entries punish people for having a past.

- **The applicant may have no phone, no address, or no email — or none that the form will accept.** No mobile, only a PO Box, an address abroad, a number with a foreign country code. People in transition, housing instability, or between countries get rejected by a required field, not by their qualifications.

- **A job can span multiple companies, roles, supervisors, and locations at once.** A consultant placed at three client sites, an employee whose role changed mid-tenure, a job split across an office and the field — one row, one dropdown, one supervisor field can't capture any of it.

- **The applicant may never have gone to school — or went to one that doesn't fit your dropdowns.** Self-taught, apprenticed, homeschooled, foreign institutions, non-degree credentials. Requiring "BA or BSc" and a GPA assumes a specific country's specific education system.

## Where It Gets Complicated

### One job ≠ one company, one role, one supervisor

A single position is rarely the atomic unit forms assume it to be.

- **One job, many companies.** A contractor or agency worker may serve several clients under one engagement.
- **One job, many roles.** Titles and responsibilities shift over time within the same employment.
- **One job, many supervisors — or none.** Some jobs have multiple managers; some have none at all (you're the boss, or it's a flat collective, or there simply isn't one).
- **Jobs don't always have a clear title or description.** "What did you do?" can be genuinely hard to compress into a job title, especially in small businesses where one person does everything.

### Time isn't linear or tidy

- **Jobs don't always have set start and end dates.** Seasonal, on-call, project-based, and open-ended work resist clean date fields.
- **Jobs recur.** Someone may leave a job and return to it later, or work the same gig every winter. "When that period is done, it's done" is false.
- **Job and study history aren't linear.** People take breaks, switch fields, study and work simultaneously, or return to school decades later. A form that demands a gapless chronological ladder fails real lives.
- **The applicant has other demands on their time.** Caregiving, disability, multiple jobs, other applications in flight — the assumption that this is their only focus (or only application) is wrong on both counts.

### Place, pay, and hours

- **Jobs aren't always in a physical location** — remote, distributed, or location-irrelevant work exists.
- **A job can span multiple locations.** Field work, multi-site roles, traveling positions.
- **Pay is irregular.** Commission, piece-rate, tips, equity, stipends — "regular salary" is one model among many.
- **Pay may be in a foreign currency.** The applicant's past job paid in a currency different from the country they're applying in; a hard-coded currency or naive number field mangles it.
- **Hours are irregular.** Shift work, zero-hours contracts, on-call, gig work — "regular hours" doesn't describe most of the workforce.

### References and verification break down

- **A former supervisor may not be easily contactable** — retired, moved, deceased, estranged, or simply gone.
- **References aren't always former supervisors.** Self-employed people, founders, and those who clashed with a boss may offer peers, clients, or collaborators instead.
- **The former company may be gone**, so there's no one to verify employment at all.

### Education doesn't fit the dropdowns

- **The applicant may not have attended a conventional school or university** — or any at all.
- **Degrees don't fit "BA or BSc" / "MA or MSc."** Other countries and systems use entirely different credential names and structures.
- **Degree subjects don't fit a narrow list.** Interdisciplinary, niche, or untranslatable fields don't map to a fixed dropdown.
- **Grades aren't always GPA.** Many systems use percentages, classes, marks out of different totals, or no numeric grade at all — and they don't translate cleanly to the convention of the hiring country.
- **Core qualifications may come from neither a degree nor a "regular" job** — self-teaching, life experience, hobby projects, or informal work.

### Geography and identity

- **The applicant's job history may be in another country.** Foreign employers, foreign phone numbers, foreign currencies, foreign verification.
- **The applicant may have studied in another country**, with all the credential-mismatch problems that brings.
- **The applicant's visa may not have a clear end date** — or any fixed status — even when the form demands one.
- **The applicant's experience or education may not resemble the job at all.** Career changers and unconventional backgrounds are common; assuming relevance must be linear is wrong.

## If You Build This

- **Make almost everything optional and freeform-capable.** Salary, manager, GPA, dates, phone, address, school — every field that seems mandatory is missing for someone real. Allow "not applicable," "self-employed," "prefer not to say," and free text instead of forcing dropdowns.

- **Stop assuming one-to-one relationships.** Let a job have multiple roles, locations, and supervisors — or none. Model employment as flexible records, not fixed rows with single-value fields.

- **Never require verification you can't guarantee exists.** Former companies fold, supervisors vanish, names change. Don't reject an application because a reference is unreachable or an old employer's number is dead.

- **Internationalize from the start.** Currencies, phone formats, address formats, education systems, and grading scales differ everywhere. Don't hard-code your own country's conventions as the only valid input.

- **Don't penalize gaps, non-linearity, or "irrelevant" history.** Career breaks, field switches, and unconventional paths are normal. Build for the messy real career, not the idealized ladder — and remember the applicant has a life and other applications competing for their time.


## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Job Applicants (creatrixtiara)](https://medium.com/@creatrixtiara/falsehoods-programmers-believe-about-job-applicants-99280437c616) · [archived copy](../archive/job-applicants/01-falsehoods-about-job-applicants-creatrixtiara.md)
