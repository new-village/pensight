# Peninsight

Peninsight is a note-taking and management application built with Flutter. It lets you create, rename, and delete notes using a sticky note–style interface with support for responsive design and theme customization.

## Features
- Create, edit, and delete notes
- Customizable font size for note content
- Responsive design for both desktop and mobile devices
- Dark mode and light mode themes

## Future Improvements
- **Note Formatting**: Enhance the editor to support rich text formatting.
- **Login Functionality**: Implement user authentication so that each user can manage personal notes.
- **Saving Feature**: Add persistent storage to save and retrieve notes.
- **LLM Integration**: Integrate with a large language model for advanced note analysis and assistance.
- **GitHub Pages Publishing**: Publish the application on GitHub Pages for easier distribution.

## Getting Started
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run `flutter run` to launch the application.

## lib Directory
- main.dart: The entry point of the Flutter application.
- app.dart: Initializes the main theme and sets up the home screen.
- notes_page.dart: Manages the list of notes and the main user interface.
- models/note.dart: Defines the Note data class with title and content.
- widgets/ruled_background.dart: Provides a lined paper background for note editing.
- widgets/management_menu.dart: Displays a dialog to configure settings like dark mode and font size.
- widgets/fab_sub_button.dart: A smaller FAB with a label for sub-menu actions.
- widgets/note_editor.dart: A text editor widget with lined background support.
- widgets/note_list.dart: Renders a list of notes with swipe-to-delete and long-press rename.

## License
This project is licensed under the MIT License.