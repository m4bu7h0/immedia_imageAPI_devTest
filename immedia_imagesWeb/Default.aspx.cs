using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using System.Web.UI;
using immedia_imagesDomain.docking;
using Telerik.Web.UI;

namespace immedia_imagesWeb {
    public partial class _Default : Page {
        protected void Page_Load(object sender, EventArgs e) {

        }

        [System.Web.Script.Services.ScriptMethod()]
        [System.Web.Services.WebMethod]
        public static List<string> SearchCustomers(string prefixText, int count, string contextKey)
        {
            return null;
        }

        //[WebMethod]
            //public static AutoCompleteBoxData GetAutoComplete(object context) {
            //    var searchString =
            //        ((Dictionary<string, object>)context)["Text"]
            //        .ToString();
            //    var result = new List<AutoCompleteBoxItemData>();

            //    result.AddRange(
            //        DockingHub.GetAutocomplete(searchString).Select(
            //            j => new AutoCompleteBoxItemData {
            //                Text = j.ToString(), Value = j.ToString()
            //            }));
            //    var res = new AutoCompleteBoxData {
            //        Items = result.ToArray()
            //    };

            //    return res;
            //}
        }
}