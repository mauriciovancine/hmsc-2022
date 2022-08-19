#  HMSC course 2022

## Organizado como parte da escola de verão de Jyvashyla

### Course site

[site](https://www.helsinki.fi/en/researchgroups/statistical-ecology/software/hmsc)

## Schedule

---

### Monday 15th August 2022

*Plenary sessions*

- Lecture (by Otso Ovaskainen). Welcome & introduction to the course.
- Lecture (by Otso Ovaskainen). Overview of HMSC.
- Introduction to case studied used in this course: plants, birds, fungi, and phenology.
- R demonstration (by Otso Ovaskainen). What is the Hmsc pipeline and how to apply it? Setting up a model, fitting it, and producing standard output.
- Lecture (by Otso Ovaskainen). Introduction to the case study to be used in the break-out groups.

Slides
- [L1 welcome](https://www.helsinki.fi/assets/drupal/2022-08/L1%20welcome.pdf)
- [L2 overview of HMSC](https://www.helsinki.fi/assets/drupal/2022-08/L2%20overview%20of%20HMSC.pdf)

Videos
- [L1 welcome](https://youtu.be/USqztEnJxyw)
- [L2 overview of HMSC | Introduction to case studied](https://youtu.be/qMZKYHcXoKw)
- [R demonstration](https://youtu.be/duPLbotR054)

Material
- [Introduction to case studies](https://www.helsinki.fi/assets/drupal/2022-08/Introduction%20to%20case%20studies.pdf)
- [Case study: Plants](https://www.dropbox.com/s/4oqs0p539j19yu5/case%20study%20plants.zip?dl=0)
- [Case study: Birds](https://www.dropbox.com/s/cwp7euhanvjhqxi/case%20study%20birds.zip?dl=0)
- [Case study: Fungi](https://www.dropbox.com/s/wa7zei3lkndp78e/case%20study%20fungi.zip?dl=0)
- [Case study: Phenology](https://www.dropbox.com/s/jobahs38mh40eyg/case%20study%20phenology.zip?dl=0)
- [How to apply the Hmsc pipeline](https://www.helsinki.fi/assets/drupal/2022-08/How%20to%20apply%20the%20Hmsc%20pipeline.pdf)
- [Hmsc pipeline](https://www.dropbox.com/s/08ptxne82x7bpqd/Hmsc%20pipeline.zip?dl=0)

*Break-out groups*

Exercise 1. Apply the Hmsc pipeline to the provided case study data. Define a simplified Hmsc model (no traits, no phylogeny, no random effects), and follow the Hmsc pipeline to generate basic output on parameter estimates. Participants are encouraged to work independently, the teacher is there mainly to help if questions arise.

Video
- [Introduction to the case study to be used in the break-out groups](https://youtu.be/duPLbotR054?t=2520)

Material
- [Case study: Exercises](https://www.dropbox.com/s/xqlx2t1brr7p9mx/case%20study%20exercises.zip?dl=0)

---

### Tuesday 16th August 2022

*Plenary sessions*

- R demonstration (by Otso Ovaskainen). Recap of Exercise 1.
- Lecture (by Otso Ovaskainen). The fixed and random effect components of HMSC and their links to ecological theory.
- Lecture (by Sara Taskinen): Using variational approximation for fast estimation of joint species distribution models with various response distributions (note: this lecture is not related to HMSC but to joint species distribution modelling more generally).

Slides
- [L3 fixed and random effects](https://www.helsinki.fi/assets/drupal/2022-08/L3%20fixed%20and%20random%20effects_160822.pdf)
- [L4 lecture_by_Sara_Taskinen](https://www.helsinki.fi/assets/drupal/2022-08/L4_lecture_by_Sara_Taskinen.pdf)

Videos
- [Recap of Exercise 1](https://youtu.be/N4nxpPLgx9M)
- [L3 fixed and random effects](https://youtu.be/N4nxpPLgx9M?t=4682)
- [L4 lecture_by_Sara_Taskinen](https://youtu.be/8lm3DErb2mY)

*Break-out groups*

Exercise 2. Continue from Exercise 1 by defining a full HMSC model (with traits, phylogeny, and random effects) and apply the Hmsc pipeline to produce some basic model outputs.

---

### Wednesday 17th August 2022

*Plenary sessions*

- R demonstration (by Otso Ovaskainen). Recap of Exercise 2.
- R demonstration (by Otso Ovaskainen). Measuring explanatory and predictive power by different cross-validation strategies.
- R demonstration (by Otso Ovaskainen). Making predictions over environmental gradients.
- R demonstration (by Otso Ovaskainen). Checking MCMC convergence and examining model fit.
- Lecture (by Gleb Tikhonov). How is Hmsc fitted to data? Overview on prior distributions and posterior sampling.
- R demonstration (by Gleb Tikhonov). How to modify the prior distributions and make choices related to posterior sampling.

Slides
- [L5 How is HMSC fitted to data](https://www.helsinki.fi/assets/drupal/2022-08/L5_How%20is%20HMSC%20fitted%20to%20data.pdf)

Videos
- [Recap of Exercise 2](https://youtu.be/_zylFuNq7Pk)
- [L5 How is HMSC fitted to data](https://youtu.be/N4nxpPLgx9M?t=4682)

*Break-out groups*

- Exercise 3. Continue from Exercise 2 by checking MCMC convergence, examining model fit, and making predictions over environmental gradients.

---

### Thursday 18th August 2022

*Plenary sessions*

- R demonstration (by Otso Ovaskainen). Recap of Exercise 3.
- R demonstration (by Otso Ovaskainen). How to set up different types of random levels in Hmsc: hierarchical, spatial and temporal.
- R demonstration (by Otso Ovaskainen). Setting up different response distributions.
- R demonstration (by Otso Ovaskainen). Making predictions over spatial gradients.
- Lecture and R demonstration (by Otso Ovaskainen). Variable selection, reduced rank regression, and other methods to deal with cases with many potential covariates.

Slides
- [L6](https://www.helsinki.fi/assets/drupal/2022-08/L5_How%20is%20HMSC%20fitted%20to%20data.pdf)

Videos
- [Recap of Exercise 3](https://youtu.be/ly2-8uEJ5HI)
- [L6](https://youtu.be/8lm3DErb2mY)

*Break-out groups*

- Exercise 4. Continue from Exercise 3 by trying out different models and selecting among them.

Friday 19th August 2022

*Plenary sessions*

- R demonstration (by Otso Ovaskainen). Recap of Exercise 4.
- Discussion session (lead by Otso Ovaskainen, Gleb Tikhonov and Jari Oksanen). Recent and future development needs of HMSC: Overview of recently implemented and ongoing developments, and discussion on what users would like to see implemented.
- Discussion session. Based, e.g., on questions that came up during lectures and/or break-out groups that could not have been addressed there.

Slides
- [L7](https://www.helsinki.fi/assets/drupal/2022-08/L5_How%20is%20HMSC%20fitted%20to%20data.pdf)

Videos
- [Recap of Exercise 4](https://youtu.be/nZy-ic6j4bI)
- [L7](https://youtu.be/N4nxpPLgx9M?t=4682)

*Break-out groups*

- In the break-out groups, discussions on topics suggested by the participants, including guidance on working with their own data.

---
