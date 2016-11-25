# curricualized: _visualizing curriculum mapping_

>Curriculum Mapping: “representing spatially the different components of the curriculum so that the whole picture and the relationships and connections between the parts of the map are easily seen”.  Harden (2001)

The above quote may be the underlying goal of curriculum mapping, but I think it got lost along the way.

Often curriculum mapping is done as a one-off, 'fire-and-forget' method at the start of a cylical/program/curriculum review. This is despite the fact, that once most  program undertake curriculum mapping, they tend to learn a great deal about the how their programs are structure, how they are taught, how they are assessed and how the students develop the intended outcomes.

This typically isn't due to mass apathy, laziness or a lack of time.  Once a curriculum map is developed, it can easily be modified to reflect changes. However, "easy" is relative to resolution/granularity

   * Maps with a very big resolution can be modified easy, as they contain large grains of information *(courses,semesters, etc.)*

   * Maps with a very small resolution are more difficult to modified, as they contain very fine grains of information *(assessments, weeks)*  

A more pressing issue is what one actually gets out of a curriculum map, or _what it tells you_.  In most cases, the curriculum map is simply presented as a matrix, a table, or a gantt-style chart at best.  Some standard methods of visualizing curriculum mapping information, such as bar charts and pie charts fail to illustrate the mapping informatio in a way that maximizes the utility of the data and presents it in an effective manner.  For instance:

![](https://raw.githubusercontent.com/jkaupp/curricualized/master/image/traditional.png)


This view of the curriculum doesn't lend itself to be easily understood, and doesn't provide a great deal of meaning beyond those that created the map.

I believe that it is the combination of incorrect granularity of mapping and and the lack of meaningful visualization options that is the key obstacle impeding meaningful and continuous curriculum mapping.  To illustrate this point, below is a reimagining of the previous bar and pie charts.  This version maintains the ideas behind the original but provides additional content by illustrating the granularity and clearer progression of the attributes through the curriculum.  

![](https://raw.githubusercontent.com/jkaupp/curricualized/master/image/updated.png)


---

# How can it be better?

The mapping process is very well detailed, and is tried and true.  However, it sometimes gets lead astray by focusing  questions and collection at the wrong level of granularity.  Take for instance, one created at the program level that simply looks at outcomes developed at the course level.  This produceds a map that shows how students progress through the curriculum, and how they develop outcomes, but it has difficult answering questions that are targeted *within* courses, about students or assessment.  

On the other hand, a fine grain map contains all the information relative to the students.  What the assessments were, how many there are, how they were assessed, when and by whom?  All of these can be "rolled up" or aggregated into a course, and represent a larger grain by a collection of smaller grains.

Essentially a large grain map can only answer questions relative to itself or aggregate above, where as a fine grain can be aggregated up to address nearly any level.

This is my argument for conducting mapping at the finest level of granularity: _What the student does_.

---

# How would it work?

**If it ain't broke**: The collaborative mapping approach works, and should be followed.  However, the questions aksed in a typical mapping approach should be tailored to ask specific questions at the student-level grain.  The process usually begins by asking questions of your faculty, such as:

* What methods of instruction do you use in your course? (**What**)
* What methods of assessment are used in your course? (**How**)
* Which program-level learning outcomes are developed in your course? (**What**)
* What level of complexity/depth is expected for each of the learning outcomes? (**Level**)
* Please specify how each of the learning outcomes are taught and assessed in your course. (**How**)

These questions provide depth and 		insight but are targeted at the course-level and only indirectly address _what the student does_. They also only infer **When**, by knowing that the course offering happens at a certain time.  Additionally, there is no information pertaining to **Who** assesses the students.  

By expanding the questions, and focusing them towards student activity, these questions can address elements of **What**, **How**, **When**, **Who** as well as potential areas of **Complexity**, **Scaffolding**, and **Expectations**. These are question such as:

* What are your course learning outcomes? (**What**)
* Does your course specifically develop the CLO? (**How**)
* Which Program level learning outcomes (indicators/GA's) map to your CLOs (**What**)
* What are your assessments? (**How**)
* When do these occur? (**When**)
* Which CLOs map to which assessment? (**Where**)
* What is the type of each assessment? (**What**)
* What is the complexity of the assessment? (**Complexity**)
* What scaffolding is provided in the assessment? (**Scaffolding**)
* How long between instruction and assessment of CLO? (**How**)
* Who assesses student work? (**Who**)
* What are the expectations for achieving the outcome? (**Expectations**)

These questions can be delivered in a survey

|Course-level Outcome | Indicator   | Graduate Attribute | Assessment | Date of Instruction | Date of Assessment | Assessment Type | Assessed by | Complexity             | Scaffolding          | Expectations |
|:-------------------:|:-----------:|:------------------:|:----------:|:------------------: |:------------------:|:---------------:|:-----------:|:----------------------:|:--------------------:|:------------:|
|   CLO1              | APSC-1-DE-2 |       DE           |    MEA 1   | 10/15/2015          |     10/31/2015     |       OEP       |     TA      | Open-ended, Ill defined| Restriction of scope | Rubric lvl 3 |


The next step is creating the two main elements of a curriculum map to be visualized

1. A Base Map:  This is a mxn matrix with Outcomes on Rows and Container on columns.  This essentially maps "curriculum events" to the specific container.  In most cases the container is a specific course, but be drilled down or scaled up appropriately.
2. Encoding Matrix: This is a look-up table that contains all the necessary information to compute a mapping scheme, or multiple mapping schemes. This can include typical curriculum mapping approaches, such as alignment mapping (Taught, Utilized, Assessed), development mapping (Introduce, Develop, Master) or specific approaches (Introduce, Develop, Apply).

---

# What does it look like?

Once you arrange your mapping information into a Base Map and Encoding Matrix, you have essentially created a hierarchical data structre that can be visualized using the many different types of data contained therein.  In the case of curriculum mapping, this data would be best represented as:

1. temporal data
2. hierarchical data



For example, a treemap visualization of the curriculum by attribute and course:

![](https://raw.githubusercontent.com/jkaupp/curricualized/master/image/GA_treemap.png)

or produce a [collapsible dendrogram visualization][dendro] of the outcomes structure from the basemap

[dendro]: http://bl.ocks.org/jkaupp/c7affaad7ea147c79799

---

# What does it get used for?

The approach and it's visualizations aren't a stand-alone, or a replacement for the full collaborative currriuclum mapping process.  They are intended to be an improvement on traditional approaches, and provide support for the key stages of collaborative curriculum decision making as shown below:

![](https://raw.githubusercontent.com/jkaupp/curricualized/master/image/curmapcircle.jpg)


The foremost goal of this approach is to provide insight and inform collaborative curriculum discussions and seeks to do so by providing insight by providing visualizations to answer the guiding questions for curriculum mapping decisions[1]

###Instructional & Assessment Methods

1. What instructional/assessment strategies are we most/least using?
2. Are the instructional and assessment methods used in the courses congruent with the discipline and our program’s/College’s/Institution’s mission/vision?
3. Are the instructional and assessment methods used in the courses congruent with the discipline’s signature pedagogies?
4. In terms of supporting student learning, how well are the instructional and assessment methods that we use actually working?  

###Learning Outcomes

1. What learning outcomes are we most/least emphasizing?
2. Where are the strengths and gaps in the teaching and assessment of these learning outcomes?
3. Do the instructional and assessment methods that we are using best align with the intended learning outcomes?
4. Are these learning outcomes appropriate? Are there any omissions?  Is clarification warranted?

###Workload and Progression

1. How is student workload distributed across the semester?
2. Have students/faculty expressed concern over workload at particular times of the semester? Is there opportunity to more evenly distribute the workload?
3. How is student learning progressing for each of the learning outcomes?
4. Are students provided adequately with an opportunity to progress towards their achievement of each learning outcome?

###General

1. What data presented most surprised you? Why?
2. Where are our strengths?  What are we doing well?
3. Do these results align or conflict with any other curriculum assessment results or past program reviews (e.g. student/faculty/employee feedback)? Why?  How so?  Where are there areas of congruency or divergence?
4. What are the next steps we can take improve, align, and integrate our curriculum?

---

#References

[1] 'Learning Outcomes Curriculum Mapping'. 2015. Web. 14 Apr. 2015. http://www.uoguelph.ca/vpacademic/avpa/outcomes/curriculummap.php
