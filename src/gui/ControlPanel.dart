import 'dart:html';

/**
 * The class where the user can control physics settings
 */
class ControlPanel {

    //The HTML element where the control panel is housed
    DivElement controlPanel;
    //The HTML that houses all of the widgets the user can mess with to alter the simulation
    TableElement uiContainer;
    //A list of the functions that will update all of the output fields; called periodically in update
    List<Function()> outputUpdaters = [];

    /**
     * Constructor for a Control Panel that sets all of the ControlPanel attributes
     */
    ControlPanel() {
        this.controlPanel = document.getElementById('control-panel');
        this.uiContainer = new TableElement();
        this.controlPanel.append(this.uiContainer);
        TableRowElement titleRow = new TableRowElement();
        HtmlElement sectionTitle = document.createElement("th");
        sectionTitle.innerHtml = "Section";
        HtmlElement attributeTitle = document.createElement("th");
        attributeTitle.innerHtml = "Attribute";
        HtmlElement valueTitle = document.createElement("th");
        valueTitle.innerHtml = "Value";
        HtmlElement unitsTitle = document.createElement("th");
        unitsTitle.innerHtml = "Units";
        titleRow.append(sectionTitle);
        titleRow.append(attributeTitle);
        titleRow.append(valueTitle);
        titleRow.append(unitsTitle);
        this.uiContainer.append(titleRow);
        this.addBreak();
    }

    /**
     * Adds a horizontal break to the control panel
     */
    void addBreak() {
        this.uiContainer.append(new BRElement());
    }

    /**
     * Adds a numeric input field to the uiContainer
     */
    void addNumericInput(String section, String attribute, double value, String units, double min, double max, double step, Function(double) inputHandler) {
        TableRowElement rowElement = new TableRowElement();
        TableCellElement sectionCell = new TableCellElement();
        sectionCell.innerHtml = section;
        TableCellElement attributeCell = new TableCellElement();
        attributeCell.innerHtml = attribute;
        TableCellElement unitsCell = new TableCellElement();
        unitsCell.innerHtml = units;

        TableCellElement inputCell = new TableCellElement();
        InputElement numericInputElement = new InputElement(type: "number");
        numericInputElement.setAttribute("min", "$min");
        numericInputElement.setAttribute("max", "$max");
        numericInputElement.setAttribute("step", "$step");
        numericInputElement.value = "$value";
        numericInputElement.onInput.listen( (ignored) => inputHandler(double.parse(numericInputElement.value)) );
        inputCell.append(numericInputElement);

        rowElement.append(sectionCell);
        rowElement.append(attributeCell);
        rowElement.append(inputCell);
        rowElement.append(unitsCell);
        this.uiContainer.append(rowElement);
    }

    /**
     * Adds a text input field to the uiContainer
     */
    void addTextInput(String section, String attribute, String value, String units, Function(String) inputHandler) {
        TableRowElement rowElement = new TableRowElement();
        TableCellElement sectionCell = new TableCellElement();
        sectionCell.innerHtml = section;
        TableCellElement attributeCell = new TableCellElement();
        attributeCell.innerHtml = attribute;
        TableCellElement unitsCell = new TableCellElement();
        unitsCell.innerHtml = units;

        TableCellElement inputCell = new TableCellElement();
        InputElement inputElement = new InputElement(type: "text");
        inputElement.value = value;
        inputElement.onInput.listen( (ignored) => inputHandler(inputElement.value) );
        inputCell.append(inputElement);

        rowElement.append(sectionCell);
        rowElement.append(attributeCell);
        rowElement.append(inputCell);
        rowElement.append(unitsCell);
        this.uiContainer.append(rowElement);
    }

    /**
     * Adds an output field to the uiContainer; whether it is numeric or not doesn't matter because it isn't editable
     * Output should only be used to show what is going on, not to take user input
     */
    void addOutputField(String section, String attribute, String value, String units, String Function() outputHandler) {
        TableRowElement rowElement = new TableRowElement();
        TableCellElement sectionCell = new TableCellElement();
        sectionCell.innerHtml = section;
        TableCellElement attributeCell = new TableCellElement();
        attributeCell.innerHtml = attribute;
        TableCellElement unitsCell = new TableCellElement();
        unitsCell.innerHtml = units;

        TableCellElement outputCell = new TableCellElement();
        InputElement outputElement = new InputElement();
        outputElement.disabled = true;
        outputElement.style.backgroundColor = "rgba(150,150,150,50)";
        outputElement.value = value;
        this.outputUpdaters.add(() {
            outputElement.value = outputHandler();
        });
        outputCell.append(outputElement);

        rowElement.append(sectionCell);
        rowElement.append(attributeCell);
        rowElement.append(outputCell);
        rowElement.append(unitsCell);
        this.uiContainer.append(rowElement);
    }

    /**
     * Adds an action button to the ui container
     */
    void addActionButton(String section, String attribute, String actionName, String units, Function() action) {
        TableRowElement rowElement = new TableRowElement();
        TableCellElement sectionCell = new TableCellElement();
        sectionCell.innerHtml = section;
        TableCellElement attributeCell = new TableCellElement();
        attributeCell.innerHtml = attribute;
        TableCellElement unitsCell = new TableCellElement();
        unitsCell.innerHtml = units;

        TableCellElement actionCell = new TableCellElement();
        ButtonElement buttonElement = new ButtonElement();
        buttonElement.innerHtml = actionName;
        buttonElement.onClick.listen(([Event ignored]) => action());
        actionCell.append(buttonElement);

        rowElement.append(sectionCell);
        rowElement.append(attributeCell);
        rowElement.append(actionCell);
        rowElement.append(unitsCell);
        this.uiContainer.append(rowElement);
    }

    /**
     * Updates the control panel by updating output fields
     */
    void update() {
        this.outputUpdaters.forEach( (updater) => updater() );
    }

}
