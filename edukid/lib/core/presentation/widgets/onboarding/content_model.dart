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
      title: 'Ahoy!',
      description: "Io sono Jack, il pappagallo!\nSei pronto per un'avventura?"
      ),
  OnboardingContent(
      image: 'assets/images/desperate.png',
      title: "Alcuni pirati hanno rubato tutte le mie monete!",
      description: 
      "\nPer aiutarmi a riprenderle dovrai rispondere alle loro domande: per ogni risposta giusta otterrai 5 monete.\nMa stai attento perchè una risposta sbagliata ti costerà 3 monete!"),
  OnboardingContent(
      image: 'assets/images/correct.png',
      title: 'Aiutami!',
      description: "Sembri essere la persona perfetta!\nHo davvero bisogno del tuo aiuto per riprendermi le monete!\nSei pronto per questa sfida?")
];
