import 'package:book_finder/models/book.dart';

/// list of all supported genres
List<String> genres = [
  'Drama',
  'Fantasy',
  'Novel',
  'Mythology',
  'Comic',
  'Technical',
  'Science',
  'Fable',
  'Sonnet',
  'Legends',
  'Tragedy',
  'Ballads',
  'Fairy tale',
  'Romance',
  'Poetry',
  'Adventure',
  'Mystery',
  'Religion',
  'Science fiction',
  'History',
  'Thriller',
  'Crime',
  'Folklore',
  'Detective',
  'Horror',
  'Lyrics',
  'Childrens tale',
  'Classic',
  'Love story',
  'Other',
];

/// list of pre-filled books for library
List<Book> libraryBooks = [
  Book(title: 'Life 3.0: Being Human in the Age of Artificial Intelligence', author: 'Max Tegmark', date: DateTime.parse('2017-08-23'), genre: 'Science',
      description: 'AI is the future - but what will that future look like? Will superhuman intelligence be our slave, or become our god?\n\n'
          'Taking us to the heart of the latest thinking about AI, Max Tegmark, the MIT professor whose work has helped mainstream research on how '
          'to keep AI beneficial, separates myths from reality, utopias from dystopias, to explore the next phase of our existence.'
          '\n\nHow can we grow our prosperity through automation, without leaving people lacking income or purpose? How can we ensure that future AI '
          'systems do what we want without crashing, malfunctioning or getting hacked? Should we fear an arms race in lethal autonomous weapons? '
          'Will AI help life flourish as never before, or will machines eventually outsmart us at all tasks, and even, perhaps, replace us altogether?'),
  Book(title: 'Permanent Record', author: 'Edward Snowden', date: DateTime.parse('2019-09-17'), genre: 'Drama',
      description: 'Edward Snowden, the man who risked everything to expose the US government’s system of mass surveillance, reveals for the first'
          ' time the story of his life, including how he helped to build that system and what motivated him to try to bring it down.'
          'In 2013, twenty-nine-year-old Edward Snowden shocked the world when he broke with the American intelligence establishment '
          'and revealed that the United States government was secretly pursuing the means to collect every single phone call, text message, '
          'and email. The result would be an unprecedented system of mass surveillance with the ability to pry into the private lives of every '
          'person on earth. Six years later, Snowden reveals for the very first time how he helped to build this system and why he was moved to expose it.'),
  Book(title: 'Start-up Nation: The story of Israel\'s Economic Miracle', author: 'Dan Senor and Saul Singer', date: DateTime.parse('2011-09-01'), genre: 'History',
      description: 'Start-Up Nation addresses the trillion dollar question: How is it that Israel -- a country of 7.1 million, only 60 years old, '
          'surrounded by enemies, in a constant state of war since its founding, with no natural resources-- produces more start-up companies than large, '
          'peaceful, and stable nations like Japan, China, India, Korea, Canada and the UK?\n\nWith the savvy of foreign policy insiders, Senor and Singer '
          'examine the lessons of the country\'s adversity-driven culture, which flattens hierarchy and elevates informality-- all backed up by government '
          'policies focused on innovation. In a world where economies as diverse as Ireland, Singapore and Dubai have tried to re-create the "Israel effect", '
          'there are entrepreneurial lessons well worth noting. As America reboots its own economy and can-do spirit,'
          ' there\'s never been a better time to look at this remarkable and resilient nation for some impressive, surprising clues.'),
  Book(title: 'Insight Out: Get Ideas Out of Your Head and Into the World', author: 'Tina Seelig', date: DateTime.parse('2007-04-24'), genre: 'Technical',
      description: 'In this revolutionary guide, Stanford University Professor and international bestselling author of inGenius adopts '
          'her popular course material to teach everyone how to make imaginative ideas a reality. \n\nAs a leading expert on creativity, '
          'Tina Seelig has continually explored what we can each do to unleash our entrepreneurial spirit. In Insight Out, she offers us'
          ' the tools to make our ideas a reality. She clearly defines the concepts of imagination, creativity, innovation, and entrepreneurism, '
          'showing how they affect each other and how we can unlock the pathway from imagination to implementation, where our ideas then gain the '
          'power to inspire the imaginations of others. \n\nDrawing on more than a decade of experience as a professor at the Stanford University'
          ' School of Engineering, Seelig shows readers how to work through the steps of imagination, ideation, innovation, and implementation, '
          'using each step to build upon the last, to ultimately create something complex, interesting, and powerful. Coping with today’s constant '
          'change, everyone needs these skills to conquer challenges and seize the opportunities that arise. Seelig irrefutably demonstrates that '
          'these skills can be taught, and shows us how to mobilize our own energy and bring new ideas to life..'),
  Book(title: '1984', author: 'George Orwell', date: DateTime.parse('1949-08-06'), genre: 'Science Fiction',
      description: 'Winston Smith works for the Ministry of Truth in London, chief city of Airstrip One. '
          'Big Brother stares out from every poster, the Thought Police uncover every act of betrayal.'
          ' When Winston finds love with Julia, he discovers that life does not have to be dull and deadening, and awakens to new possibilities. '
          'Despite the police helicopters that hover and circle overhead, Winston and Julia begin to question the Party; they are drawn towards conspiracy. '
          'Yet Big Brother will not tolerate dissent - even in the mind. For those with original thoughts they invented Room 101...'),
  Book(title: 'Sapiens: A Brief History of Humankind', author: 'Yuval Noah Harari', date: DateTime.parse('2015-04-30'), genre: 'History',
      description: 'What makes us brilliant? What makes us deadly? What makes us Sapiens? Yuval Noah Harari challenges everything we know about '
          'being human in the perfect read for these unprecedented times.Earth is 4.5 billion years old. In just a fraction of that time, one species'
          ' among countless others has conquered it: us.In this bold and provocative book, Yuval Noah Harari explores who we are, how we got here and where we\'re going.')
];

