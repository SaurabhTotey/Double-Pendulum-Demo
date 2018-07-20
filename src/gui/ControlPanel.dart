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
    void addInputField(String title, String name, Function(String) inputHandler, {String initialValue = "", String units = ""}) {
        ParagraphElement containerElement = new ParagraphElement();
        SpanElement titleElement = new SpanElement();
        titleElement.setAttribute("class", "title");
        titleElement.innerHtml = title;
        containerElement.append(titleElement);
        SpanElement labelElement = new SpanElement();
        labelElement.setAttribute("class", "label");
        labelElement.innerHtml = " $name";
        containerElement.append(labelElement);
        SpanElement inputContainer = new SpanElement();
        inputContainer.setAttribute("class", "input");
        InputElement inputElement = new InputElement(type: "text");
        inputElement.value = initialValue;
        inputElement.onInput.listen((Event e) {
            inputHandler(inputElement.value);
        });
        inputContainer.append(inputElement);
        SpanElement unitsElement = new SpanElement();
        unitsElement.setAttribute("class", "units");
        unitsElement.innerHtml = units;
        inputContainer.append(unitsElement);
        containerElement.append(inputContainer);
        this.controlPanel.append(containerElement);
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