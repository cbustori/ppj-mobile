enum EventsTab { today, tomorrow, soon }

class EventsTabHelper {
  static EventsTab getTabByIndex(int index) {
    switch (index) {
      case 0:
        return EventsTab.today;
      case 1:
        return EventsTab.tomorrow;
      case 2:
        return EventsTab.soon;
      default:
        return EventsTab.today;
    }
  }
}
