Anna Mándoki, 5<sup>th</sup>April 2023

# Certified B Corporations Project Description and Notes

## About the B Corp certification
### Summary
Certified B Corporations are companies that meet the highest standards of verified social and environmental performance, transparency and accountability.

B Corp certification is a private certification by non-profit organization B Lab that measures a company's social and environmental impact. B stands for beneficial. 

B Corp Certification is holistic, not exclusively focused on a single social or environmental issue. It requires a minimum total score of 80 on the B Impact Assessment across all impact areas.

Today, there is a growing community of more than 5,000 Certified B Corps located all around the world and across various industries.

### Becoming a Certified B Corp
A company’s pathway to becoming a Certified B Corporation varies depending on a few factors, such as the company's size and profile.

In order to achieve certification a company must:
- demonstrate high social and environmental performance by achieving a B Impact Assessment score of 80 or above and passing B Lab's risk review.
- make a legal commitment by changing their corporate governance structure to be accountable to all stakeholders, not just shareholders, and achieve benefit corporation status if available in their jurisdiction
- exhibit transparency by allowing information about their performance measured against B Lab’s standards to be publicly available on their B Corp profile on B Lab’s website

To maintain certification, Certified B Corps must update their impact assessment and verify their updated score every three years, or after a Change of Control or Initial Public Offering.

The B Impact Assessment consists of around 200 questions about the company's practices and outputs across five categories: governance, workers, community, the environment, and customers.

https://www.bcorporation.net/en-us/certification

## Data

### data.world query

data.world has a built-in query tool where we can perform SQL queries to export data. The query used for this project is based on B Lab's tutorial and sample query.

The original dataset includes previously certified B Corps along with all current B Corps. To view only current B Corps: 
    
```sql
current_status = ‘certified’
```

To have one row of data per company: 

```sql
certification_cycle = 1
```

This variable is a numerical indicator that ranks how recent the company's assessment was rated (i.e. certified). When certification_cycle = 1, that would indicate it is the company's most recent assessment. A company's second most recent assessment would get labeled a 2, etc.

https://kb.bimpactassessment.net/support/home
https://kb.bimpactassessment.net/support/solutions/articles/43000570530-using-sql-in-b-corp-impact-data-tutorial-

### Contents
#### Company characteristics:
- company name and ID assigned by B Lab
- description of the company's industry
- country and city in which the majority of the company's workers or facilities are located
- company size

#### Dates:
- date in which the company was first certified as B Corp, the most - recent date the company was certified

#### Certification scores based on 200 questions:
- overall score and scores for the different impact areas:
    - community
    - customers
    - environment
    - governance
    - workers
- "na_scores" where a question did not apply due to the company's specific circumstances

### Data dictionary

Detailed description of the values used in this project.

- **company_id**: (string) A unique identifier for each company that will not change as the company's name changes
- **company_name**: (string) The name a company uses to advertise and sell products and services
- **date_first_certified**: (date) The date in which the company was first a certified B Corp.
- **date_certified**: (datetimestamp) The most recent date the company certified B Corp. B Corp certification requires a minimum total score of 80 across all impact areas
- **industry**: (string) A more granular version of industry_category. Industry describes a company's principal product.
- **industry_category**: (string)  A high level description of a company's industry. There are 17 industry categories which help provide a general overview of a company's business activities
- **country**: (string) The country in which the majority of the company’s workers or facilities are located.
- **state**: (string) The state in which the majority of the company’s workers or facilities are located.
- **city**: (string) The city in which the majority of the company’s workers or facilities are located.
- **sector**: (string) There are five distinct sectors in which a company can be grouped. 
- **size**: (string) Company size is based on the number of workers in full-time equivalents. It does not include contractors or founders.
- **overall_score**: (decimal) A company's overall score is based on their answers to roughly 200 questions. A company begins with zero points and earns points incrementally for each indicator of positive outcome/best practice.
- **impact_area_community**: (decimal) The Community Impact Area evaluates the company's positive impact on the external communities in which the company operates, covering topics like diversity, economic impact, civic engagement, and supply chain impact
- **impact_area_customers**: (decimal) The Customers Impact Area evaluates the company's value to their direct customers and the consumers of their products or services
- **impact_area_environment**: (decimal) The Environment Impact Area evaluates the company's overall environmental stewardship, including how the company identifies and manages general environmental impacts, air &climate issues, water sustainability, and impacts on land and life
- **impact_area_governance**: (decimal) The Governance Impact Area evaluates a company's overall mission, ethics, accountability and transparency
- **impact_area_workers**: (decimal) The Workers Impact Area evaluates the company's contribution to its employees financial, physical, professional, and social well-being
- **impact_area_community_na_score**: (decimal) Captures cases within an Impact area where a question did not apply due to a company's specific circumstances. It is obtained by multiplying the percent of points earned across that Impact Area by the points available for that question.
- **impact_area_customers_na_score**: (decimal) Captures cases within an Impact area where a question did not apply due to a company's specific circumstances. It is obtained by multiplying the percent of points earned across that Impact Area by the points available for that question.
- **impact_area_environment_na_score**: (decimal) Captures cases within an Impact area where a question did not apply due to a company's specific circumstances. It is obtained by multiplying the percent of points earned across that Impact Area by the points available for that question.
- **impact_area_governance_na_score**: (decimal) Captures cases within an Impact area where a question did not apply due to a company's specific circumstances. It is obtained by multiplying the percent of points earned across that Impact Area by the points available for that question.
- **impact_area_workers_na_score**: (decimal) Captures cases within an Impact area where a question did not apply due to a company's specific circumstances. It is obtained by multiplying the percent of points earned across that Impact Area by the points available for that question.

https://data.world/blab/b-corp-impact-data/workspace/data-dictionary

## Notes

### B Corp Impact Data update as of 29 March 2023

B Lab update the B Corp Impact dataset on a quarterly basis. When I started to work on this project, the latest available version was the one last updated on the 23<sup>th</sup> December 2022. I worked through my project using that version and updated my query as the dataset got updated on the 29<sup>th</sup> March 2023.

The final version of my project is based on this latest version.

#### Differences between the previous and updated version

The steps taken when analyzing the data have not changed. A few observations I made:

| | Dec 2022 version | Mar 2023 version |
| --- | --- | --- |
| No. of rows | 5786 | 6130 |
| missing state | 6 | 5 |
| missing city | 2 | 2 |
| missing score impact_area_customers | 232 | 166 |
| missing score impact_area_workers | 574 | 559 |
| missing impact_area_customers_na_score | 232 | 166
| missing impact_area_workers_na_score | 574 | 559 |


### RECIRC - company with missing state and city
https://www.recirc.eco/

https://opencorporates.com/companies/us_ca/4101602

### Motivf - company with missing city
https://www.motivf.com/contact

### Lollipop plot inspiration
https://www.python-graph-gallery.com/182-vertical-lollipop-plot

### More on the NA scores
"When a question is “Not Applicable”, the points available in that question are redistributed to the remaining questions in that Impact Area rather than your company earning no points. The “N/A Score” that appears on your company’s B Impact Report is the equivalent points earned based on this redistribution. An N/A Score might be triggered by selecting the “N/A” answer option in a particular question, or applied automatically when questions are disabled by a gating question in the assessment."
https://kb.bimpactassessment.net/support/solutions/articles/43000575268-the-n-a-score