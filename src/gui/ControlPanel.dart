import 'dart:html';

/**
 * The class where the user can control physics settings
 */
class ControlPanel {

    //The HTML element where the control panel is housed
    DivElement controlPanel;
    //A list of the functions that will update all of the output fields; called periodically in update
    List<Function()> outputUpdaters = [];

    /**
     * Constructor for a Control Panel that sets all of the ControlPanel attributes
     */
    ControlPanel() {
        this.controlPanel = document.getElementById('control-panel');
    }

    /**
     * Adds a field to the control panel that will take user input and then pass input to the given input handler
     */
    void addInputField(String name, Function(String) inputHandler, [String initialValue = ""]) {
        ParagraphElement container = new ParagraphElement();
        SpanElement title = new SpanElement();
        title.innerHtml = name;
        container.append(title);
        InputElement input = new InputElement(type: "text");
        input.value = initialValue;
        input.onInput.listen((Event e) {
            inputHandler(input.value);
        });
        container.append(input);
        this.controlPanel.append(container);
    }

    /**
     * Adds a field to the control panel that will display whatever the outputRetriever returns
     */
    void addOutputField(String name, String Function() outputRetriever) {

    }

    /**
     * Updates the control panel by updating output fields
     */
    void update() {
        this.outputUpdaters.forEach( (updater) => updater() );
    }

}