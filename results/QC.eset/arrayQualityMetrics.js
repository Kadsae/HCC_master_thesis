// (C) Wolfgang Huber 2010-2011

// Script parameters - these are set up by R in the function 'writeReport' when copying the 
//   template for this script from arrayQualityMetrics/inst/scripts into the report.

var highlightInitial = [ false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false ];
var arrayMetadata    = [ [ "1", "MJ_04032013_GRA_1_(Rat230_2).CEL", "C43/4/14/T4.1", "adenoma", "14", "FFPE", "2013-04-03T08:06:40Z" ], [ "2", "MJ_04072014_RIE_1_(Rat230_2).CEL", "C43/4/7/F1", "foci", "7", "FFPE", "2014-07-04T09:23:48Z" ], [ "3", "MJ_04072014_RIE_10_(Rat230_2).CEL", "C43/4/10/T1.1", "adenoma", "10", "FFPE", "2014-07-04T08:24:39Z" ], [ "4", "MJ_04072014_RIE_11_(Rat230_2).CEL", "C43/4/10/T4", "adenoma", "10", "FFPE", "2014-07-04T08:32:22Z" ], [ "5", "MJ_04072014_RIE_12_(Rat230_2).CEL", "C43/4/10/F1", "foci", "10", "FFPE", "2014-07-04T08:39:57Z" ], [ "6", "MJ_04072014_RIE_13_(Rat230_2).CEL", "C43/4/10/F2", "foci", "10", "FFPE", "2014-07-04T08:47:38Z" ], [ "7", "MJ_04072014_RIE_14_(Rat230_2).CEL", "C43/4/10/F3", "foci", "10", "FFPE", "2014-07-04T08:55:29Z" ], [ "8", "MJ_04072014_RIE_15_(Rat230_2).CEL", "C43/4/10/N.1", "adjacent_tissue", "10", "FFPE", "2014-07-04T09:03:04Z" ], [ "9", "MJ_04072014_RIE_2_(Rat230_2).CEL", "C43/4/7/F2", "foci", "7", "FFPE", "2014-07-04T09:31:24Z" ], [ "10", "MJ_04072014_RIE_3_(Rat230_2).CEL", "C43/4/7/F4", "foci", "7", "FFPE", "2014-07-04T09:39:07Z" ], [ "11", "MJ_04072014_RIE_4_(Rat230_2).CEL", "C43/4/7/T1", "adenoma", "7", "FFPE", "2014-07-04T09:46:42Z" ], [ "12", "MJ_04072014_RIE_7_(Rat230_2).CEL", "C43/4/18/F2", "foci", "18", "FFPE", "2014-07-04T08:01:37Z" ], [ "13", "MJ_04072014_RIE_8_(Rat230_2).CEL", "C43/4/18/F3", "foci", "18", "FFPE", "2014-07-04T08:09:13Z" ], [ "14", "MJ_04072014_RIE_9_(Rat230_2).CEL", "C43/4/18/N", "adjacent_tissue", "18", "FFPE", "2014-07-04T08:17:04Z" ], [ "15", "MJ_04132012_GRA_1_(Rat230_2).CEL", "C43/4/10/T1.2", "nodule", "10", "N2", "2012-04-13T07:28:09Z" ], [ "16", "MJ_04132012_GRA_2_(Rat230_2).CEL", "C43/4/10/T2.1", "nodule", "10", "N2", "2012-04-13T07:46:43Z" ], [ "17", "MJ_04132012_GRA_3_(Rat230_2).CEL", "C43/4/10/N.2", "adjacent_tissue", "10", "N2", "2012-04-13T08:23:48Z" ], [ "18", "MJ_04132012_GRA_4_(Rat230_2).CEL", "C43/4/11/T1", "nodule", "11", "N2", "2012-04-13T07:54:10Z" ], [ "19", "MJ_04132012_GRA_5_(Rat230_2).CEL", "C43/4/11/T2", "nodule", "11", "N2", "2012-04-13T08:01:35Z" ], [ "20", "MJ_04132012_GRA_6_(Rat230_2).CEL", "C43/4/11/N", "adjacent_tissue", "11", "N2", "2012-04-13T08:09:01Z" ], [ "21", "MJ_06122012_GRA_1_(Rat230_2).CEL", "C43/4/14/MT", "nodule", "14", "N2", "2012-06-12T07:45:35Z" ], [ "22", "MJ_06122012_GRA_2_(Rat230_2).CEL", "C43/4/14/T3", "adenoma", "14", "N2", "2012-06-12T07:53:02Z" ], [ "23", "MJ_06122012_GRA_3_(Rat230_2).CEL", "C43/4/14/T4.2", "adenoma", "14", "N2", "2012-06-12T08:00:28Z" ], [ "24", "MJ_06122012_GRA_4_(Rat230_2).CEL", "C43/4/14/T5.2", "adenoma", "14", "N2", "2012-06-12T08:07:52Z" ], [ "25", "MJ_06122012_GRA_5_(Rat230_2).CEL", "C43/4/14/N.2", "adjacent_tissue", "14", "N2", "2012-06-12T08:15:19Z" ], [ "26", "MJ_06122012_GRA_6_(Rat230_2).CEL", "C43/4/23/T1", "adenoma", "23", "N2", "2012-06-12T08:22:47Z" ], [ "27", "MJ_06122012_GRA_7_(Rat230_2).CEL", "C43/4/23/T5", "adenoma", "23", "N2", "2012-06-12T08:30:15Z" ], [ "28", "MJ_06122012_GRA_8_(Rat230_2).CEL", "C43/4/23/T6", "adenoma", "23", "N2", "2012-06-12T08:37:39Z" ], [ "29", "MJ_06122012_GRA_9_(Rat230_2).CEL", "C43/4/23/N.1", "adjacent_tissue", "23", "N2", "2012-06-12T08:45:04Z" ], [ "30", "MJ_07112013_GRA_1_(Rat230_2).CEL", "C43/4/14/T4.3", "adenoma", "14", "FFPE", "2013-07-11T08:34:14Z" ], [ "31", "MJ_07112013_GRA_3_(Rat230_2).CEL", "C43/4/14/N.3", "adjacent_tissue", "14", "FFPE", "2013-07-11T08:05:21Z" ], [ "32", "MJ_07122013_GRA_2_(Rat230_2).CEL", "C43/4/14/T5.3", "adenoma", "14", "FFPE", "2013-07-12T08:41:09Z" ], [ "33", "MJ_09072014_RIE_5_(Rat230_2).CEL", "C43/4/7/N.2", "adjacent_tissue", "7", "FFPE", "2014-07-09T08:12:18Z" ], [ "34", "MJ_24062014_RIE_1_(Rat230_2).CEL", "C43/4/10/T2.2", "carcinoma", "10", "N2", "2014-06-24T07:44:32Z" ], [ "35", "MJ_24062014_RIE_10_(Rat230_2).CEL", "C43/4/23/T4", "carcinoma", "23", "N2", "2014-06-24T08:53:21Z" ], [ "36", "MJ_24062014_RIE_11_(Rat230_2).CEL", "C43/4/23/N.2", "adjacent_tissue", "23", "N2", "2014-06-24T09:01:06Z" ], [ "37", "MJ_24062014_RIE_2_(Rat230_2).CEL", "C43/4/10/T3", "carcinoma", "10", "N2", "2014-06-24T07:52:12Z" ], [ "38", "MJ_24062014_RIE_3_(Rat230_2).CEL", "C43/4/10/N.3", "adjacent_tissue", "10", "N2", "2014-06-24T07:59:48Z" ], [ "39", "MJ_24062014_RIE_4_(Rat230_2).CEL", "C43/4/21/T1", "carcinoma", "21", "N2", "2014-06-24T08:07:23Z" ], [ "40", "MJ_24062014_RIE_5_(Rat230_2).CEL", "C43/4/21/T5", "carcinoma", "21", "N2", "2014-06-24T08:15:04Z" ], [ "41", "MJ_24062014_RIE_6_(Rat230_2).CEL", "C43/4/21/T6", "carcinoma", "21", "N2", "2014-06-24T08:22:43Z" ], [ "42", "MJ_24062014_RIE_7_(Rat230_2).CEL", "C43/4/21/N", "adjacent_tissue", "21", "N2", "2014-06-24T08:30:18Z" ], [ "43", "MJ_24062014_RIE_8_(Rat230_2).CEL", "C43/4/23/T2", "carcinoma", "23", "N2", "2014-06-24T08:38:05Z" ], [ "44", "MJ_24062014_RIE_9_(Rat230_2).CEL", "C43/4/23/T3", "carcinoma", "23", "N2", "2014-06-24T08:45:41Z" ] ];
var svgObjectNames   = [ "pca", "dens" ];

var cssText = ["stroke-width:1; stroke-opacity:0.4",
               "stroke-width:3; stroke-opacity:1" ];

// Global variables - these are set up below by 'reportinit'
var tables;             // array of all the associated ('tooltips') tables on the page
var checkboxes;         // the checkboxes
var ssrules;


function reportinit() 
{
 
    var a, i, status;

    /*--------find checkboxes and set them to start values------*/
    checkboxes = document.getElementsByName("ReportObjectCheckBoxes");
    if(checkboxes.length != highlightInitial.length)
	throw new Error("checkboxes.length=" + checkboxes.length + "  !=  "
                        + " highlightInitial.length="+ highlightInitial.length);
    
    /*--------find associated tables and cache their locations------*/
    tables = new Array(svgObjectNames.length);
    for(i=0; i<tables.length; i++) 
    {
        tables[i] = safeGetElementById("Tab:"+svgObjectNames[i]);
    }

    /*------- style sheet rules ---------*/
    var ss = document.styleSheets[0];
    ssrules = ss.cssRules ? ss.cssRules : ss.rules; 

    /*------- checkboxes[a] is (expected to be) of class HTMLInputElement ---*/
    for(a=0; a<checkboxes.length; a++)
    {
	checkboxes[a].checked = highlightInitial[a];
        status = checkboxes[a].checked; 
        setReportObj(a+1, status, false);
    }

}


function safeGetElementById(id)
{
    res = document.getElementById(id);
    if(res == null)
        throw new Error("Id '"+ id + "' not found.");
    return(res)
}

/*------------------------------------------------------------
   Highlighting of Report Objects 
 ---------------------------------------------------------------*/
function setReportObj(reportObjId, status, doTable)
{
    var i, j, plotObjIds, selector;

    if(doTable) {
	for(i=0; i<svgObjectNames.length; i++) {
	    showTipTable(i, reportObjId);
	} 
    }

    /* This works in Chrome 10, ssrules will be null; we use getElementsByClassName and loop over them */
    if(ssrules == null) {
	elements = document.getElementsByClassName("aqm" + reportObjId); 
	for(i=0; i<elements.length; i++) {
	    elements[i].style.cssText = cssText[0+status];
	}
    } else {
    /* This works in Firefox 4 */
    for(i=0; i<ssrules.length; i++) {
        if (ssrules[i].selectorText == (".aqm" + reportObjId)) {
		ssrules[i].style.cssText = cssText[0+status];
		break;
	    }
	}
    }

}

/*------------------------------------------------------------
   Display of the Metadata Table
  ------------------------------------------------------------*/
function showTipTable(tableIndex, reportObjId)
{
    var rows = tables[tableIndex].rows;
    var a = reportObjId - 1;

    if(rows.length != arrayMetadata[a].length)
	throw new Error("rows.length=" + rows.length+"  !=  arrayMetadata[array].length=" + arrayMetadata[a].length);

    for(i=0; i<rows.length; i++) 
 	rows[i].cells[1].innerHTML = arrayMetadata[a][i];
}

function hideTipTable(tableIndex)
{
    var rows = tables[tableIndex].rows;

    for(i=0; i<rows.length; i++) 
 	rows[i].cells[1].innerHTML = "";
}


/*------------------------------------------------------------
  From module 'name' (e.g. 'density'), find numeric index in the 
  'svgObjectNames' array.
  ------------------------------------------------------------*/
function getIndexFromName(name) 
{
    var i;
    for(i=0; i<svgObjectNames.length; i++)
        if(svgObjectNames[i] == name)
	    return i;

    throw new Error("Did not find '" + name + "'.");
}


/*------------------------------------------------------------
  SVG plot object callbacks
  ------------------------------------------------------------*/
function plotObjRespond(what, reportObjId, name)
{

    var a, i, status;

    switch(what) {
    case "show":
	i = getIndexFromName(name);
	showTipTable(i, reportObjId);
	break;
    case "hide":
	i = getIndexFromName(name);
	hideTipTable(i);
	break;
    case "click":
        a = reportObjId - 1;
	status = !checkboxes[a].checked;
	checkboxes[a].checked = status;
	setReportObj(reportObjId, status, true);
	break;
    default:
	throw new Error("Invalid 'what': "+what)
    }
}

/*------------------------------------------------------------
  checkboxes 'onchange' event
------------------------------------------------------------*/
function checkboxEvent(reportObjId)
{
    var a = reportObjId - 1;
    var status = checkboxes[a].checked;
    setReportObj(reportObjId, status, true);
}


/*------------------------------------------------------------
  toggle visibility
------------------------------------------------------------*/
function toggle(id){
  var head = safeGetElementById(id + "-h");
  var body = safeGetElementById(id + "-b");
  var hdtxt = head.innerHTML;
  var dsp;
  switch(body.style.display){
    case 'none':
      dsp = 'block';
      hdtxt = '-' + hdtxt.substr(1);
      break;
    case 'block':
      dsp = 'none';
      hdtxt = '+' + hdtxt.substr(1);
      break;
  }  
  body.style.display = dsp;
  head.innerHTML = hdtxt;
}
