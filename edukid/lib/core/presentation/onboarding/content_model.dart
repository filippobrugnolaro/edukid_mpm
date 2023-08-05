class OnboardingContent {
  String image;
  String title;
  String description;

  OnboardingContent(
      {required this.image, required this.title, required this.description});
}

List<OnboardingContent> content = [
  OnboardingContent(
      image: 'assets/images/hello.png',
      title: 'Ahoy there!',
      description: " I am Jack, the parrot!\nAre you ready for an adventure?"
      ),
  OnboardingContent(
      image: 'assets/images/desperate.png',
      title: "Some sneaky pirates took all my coins!!",
      description: 
      "\nTo get them back you will have to answer their questions: for every correct answer, you'll earn 5 coins.\nBut be cautious because wrong answer will cost you 3 coins!."),
  OnboardingContent(
      image: 'assets/images/correct.png',
      title: 'Help me!',
      description: "You seem to be the perfect person for this job and I really need your help to get my money back!\nAre you ready for this challenge?")
];
