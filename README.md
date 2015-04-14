# Visualized Curriuclum
## *an alternate approach to traditional mapping*
---

Often curriculum mapping is done as a one-off, 'fire-and-forget' method at the start of a cylical/program/curriculum review. This is despite the fact, that once most  program undertake curriculum mapping, they tend to learn a great deal about the how their programs are structure, how they are taught, how they are assessed and how the students develop the intended outcomes.

This typically isn't due to mass apathy, laziness or a lack of time.  Once a curriculum map is developed, it can easily be modified to reflect changes. However, "easy" is relative to resolution/granularity
 
   * Maps with a very big resolution can be modified easy, as they contain large grains of information *(courses,semesters, etc.)*
 
   * Maps with a very small resolution are more difficult to modified, as they contain very fine grains of information *(assessments, weeks)*  

A more pressing issue is what one actually gets out of a curriculum map, or _what it tells you_.  In most cases, the curriculum map is simply presented as a matrix, a table, or a gantt-style chart at best.  This view of the curriculum doesn't lend itself to be easily understood, and doesn't provide a great deal of meaning beyond those that created the map.

I believe that it is the combination of incorrect granularity of mapping and and the lack of meaningful visualization options that is the key obstacle impeding meaningful and continuous curriculum mapping.

		*This approach is best suited for those programs and people that are familiar with curriculum mapping, and have undertaken or completed the mapping process at least once.* 

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

	* What are your course learning outcomes?
	* Does your course specifically develop the CLO?
	* Which Program level learning outcomes (indicators/GA's) map to your CLOs
	* What are your assessments?
	* When do these occur?
	* Which CLOs map to which assessment?
	* What is the type of each assessment?
	* What is the complexity of the assessment?
	* What scaffolding is provided in the assessment?
	* How long between instruction and assessment of CLO?
	* Who assesses student work?
	
These questions can be delivered in a survey
	
|Course-level Outcome | Indicator   | Graduate Attribute | Assessment | Date of Instruction | Date of Assessment | Assessment Type | Assessed by | Complexity             | Scaffolding          |
|:-------------------:|:-----------:|:------------------:|:----------:|:------------------: |:------------------:|:---------------:|:-----------:|:----------------------:|:---------------------|
|   CLO1              | APSC-1-DE-2 |       DE           |    MEA 1   | 10/15/2015          |     10/31/2015     |       OEP       |     TA      | Open-ended, Ill defined| Restriction of scope | 


The next step is creating the two main elements of a curriculum map to be visualized

1. A Base Map:  This is a mxn matrix with Outcomes on Rows and Container on columns.  This essentially maps "curriculum events" to the specific container.  In most cases the container is a specific course, but be drilled down or scaled up appropriately.
2. Encoding Matrix: This is a look-up table that contains all the necessary information to compute a mapping scheme, or multiple mapping schemes. This can include typical curriculum mapping approaches, such as alignment mapping (Taught, Utilized, Assessed), development mapping (Introduce, Develop, Master) or specific approaches (Introduce, Develop, Apply).

---

# What does it look like?

Once you arrange your mapping information into a Base Map and Encoding Matrix, you have essentially created a hierarchical data structre that can be visualized using the many different types of data contained therein.  In the case of curriculum mapping, this data would be best represented as:

1. temporal data
2. tree data

For example, a treemap visualization of the curriculum by attribute:

![](https://raw.githubusercontent.com/jkaupp/curricualized/master/image/curriculum_ga_treemap.png)

or with a finer grain, by attribute and indicator:

![](https://raw.githubusercontent.com/jkaupp/curricualized/master/image/curriculum_treemap.png)

or a [dendrogram visualization][dendro] of the outcomes structure from the basemap


[dendro]: http://raw.githubusercontent.com/jkaupp/curricualized/master/web/Dendro.html)









