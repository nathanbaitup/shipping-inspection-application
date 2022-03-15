class Channel {
  int channelID;
  String name;
  bool empty;

  Channel(this.channelID, this.name, this.empty);
}

List<Channel> getDisplayChannels(List<String> savedChannels) {
  List<Channel> displayChannels = [];

  for(int i = 0; savedChannels.length > i; i++) {
    if (savedChannels[i] != " ") {
      displayChannels.add(
          Channel(
            i,
            savedChannels[i],
            false,
          )
      );
    } else {
      displayChannels.add(
          Channel(
            i,
            "Empty",
            true,
          )
      );
    }
  }
  return displayChannels;
}
