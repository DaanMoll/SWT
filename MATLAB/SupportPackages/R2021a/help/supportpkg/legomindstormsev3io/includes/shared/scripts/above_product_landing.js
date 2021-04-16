function getProductFilteredList(mystylesheetLocation, mysourceLocation, doccentertype, langcode) {
   // The first callback runs after we get data, while the second
   // runs if we cannot get data.
   var services = {
      "messagechannel":"prodfilter",
      "webservice": getProdFilterWebServiceUrl()
   }
   
   requestHelpService({}, services,
      function(data) {
         // product filter
         var prodlist = data.prodnavlist;
         if (typeof prodlist === "string") {
            prodlist = $.parseJSON(prodlist);
         }        
         var productfilter_shortnames = new Array(prodlist.length);
         for (var i = 0; i < prodlist.length; i++) {
            productfilter_shortnames[i] = prodlist[i].shortname;
         }
			
         // addon list
         var addOnList = (typeof data.addonlist == "string") ? $.parseJSON(data.addonlist) : data.addonlist;
         var list_addons = new Array(addOnList.length);
         for (var i = 0; i < addOnList.length; i++) {
            list_addons[i] = addOnList[i].displayname.concat("@@",addOnList[i].helplocation);
         }

         // toolbox list
         var toolboxList = (typeof data.toolboxlist == "string") ? $.parseJSON(data.toolboxlist) : data.toolboxlist;
         var list_supp_software = new Array(toolboxList.length);
         for (var i = 0; i < toolboxList.length; i++) {
            list_supp_software[i] = toolboxList[i].displayname.concat("@@",toolboxList[i].helplocation);
         }

         SaxonJS.transform({
            stylesheetLocation: mystylesheetLocation,
            sourceLocation: mysourceLocation,
            stylesheetParams: {
               "doccentertype": doccentertype,
               "langcode": langcode,
               "productfilter_shortnames": productfilter_shortnames,
               "list_supp_software": list_supp_software,
               "list_addons": list_addons
            }
         });
      },
      function() {
         SaxonJS.transform({
            stylesheetLocation: mystylesheetLocation,
            sourceLocation: mysourceLocation,
            stylesheetParams: {
               "doccentertype": doccentertype,
               "langcode": langcode,
               "productfilter_shortnames": [],
               "list_supp_software": [],
               "list_addons": []
              }
         });
      }
   );
}
