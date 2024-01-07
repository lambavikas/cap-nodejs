//It’s referring to the definitions of the earlier cds file that exposes the service and its Risks and Mitigations entities.
using RiskService from './risk-service'; 

/*annotates the Risks entity with a number of texts. 
These should be in a translatable file normally but for now we keep them here. 
These texts are used as labels in form fields and column headers by SAP Fiori elements. */
annotate RiskService.Risks with {
	title       @title: 'Title';
	prio        @title: 'Priority';
	descr       @title: 'Description';
	miti        @title: 'Mitigation';
	impact      @title: 'Impact';
}

/* The following section is needed for the value help of the Mitigation field that is visible 
when you are editing the object page of the Risks app.*/
annotate RiskService.Mitigations with {
	ID @(
		UI.Hidden,
		Common: {
		Text: description
		}
	);
	description  @title: 'Description';
	owner        @title: 'Owner';
	timeline     @title: 'Timeline';
	risks        @title: 'Risks';
}
/* This defines the content of the work list page and the object page that you navigate to 
when you click on a line in the work list */
annotate RiskService.Risks with @(
	UI: {
		//The HeaderInfo describes the key information of the object, 
		//which will make the object page to display, in this case Risk object
		HeaderInfo: {
			//Controls the plural name of the Entity shown on the table on List Page
			TypeName: 'Risk',				
			TypeNamePlural: 'Risks',
			//Define the fiels that will shown as the Title on Object Page in the Header
			Title          : {
                $Type : 'UI.DataField',
                Value : title
            },
			//Define the field that will shown as the Description on Object Page in the Header
			Description : {
				$Type: 'UI.DataField',
				Value: descr
			}
		},
		//The SelectionFields section defines which of the properties are exposed as search fields 
		//in the header bar above the list. In this case, prio is the only explicit search field.
		SelectionFields: [prio],
		//The columns and their order in the work list are derived from the LineItem section
		LineItem: [
			// in most cases the columns are defined by Value: followed by the property name of the entity
			{Value: title},
			//for fields prio and impact we also link the field criticality from the same entity 
			//that is a calculated field in our service to later show how this property is used 
			//to control the color of the cells in columns prio and impact on the work list page table
			{Value: miti_ID},
			{
				Value: prio,
				Criticality: criticality //C is always capital for the annotation property
			},
			{
				Value: impact,
				Criticality: criticality
			}
		],
		//Facets defines the content of the object page, and in this case it contains a single facet
		//of type UI.ReferenceFacet. We provide a label "Main" that shows up on the object page
		//above the facet. We define a FieldGroup name "Main" which groups together 3 properties 
		//whch are then displayed together as a field group inside this facet
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: 'Main', Target: '@UI.FieldGroup#Main'}
		],
		FieldGroup#Main: {
			Data: [
				{Value: miti_ID},
				{
					Value: prio,
					Criticality: criticality
				},
				{
					Value: impact,
					Criticality: criticality
				}
			]
		}
	},
) {

};

annotate RiskService.Risks with {
	miti @(
		Common: {
			//declares that the text from the description property is displayed for the miti association
			Text: miti.description  , TextArrangement: #TextOnly,
			//adds a value help (ValueList) for that association, so the user can pick one of 
			//the available mitigations when editing the object page.
			ValueList: {
				Label: 'Mitigations',
				CollectionPath: 'Mitigations',
				Parameters: [
					{ $Type: 'Common.ValueListParameterInOut',
						LocalDataProperty: miti_ID,
						ValueListProperty: 'ID'
					},
					{ $Type: 'Common.ValueListParameterDisplayOnly',
						ValueListProperty: 'description'
					}
				]
			}
		}
	);
}
