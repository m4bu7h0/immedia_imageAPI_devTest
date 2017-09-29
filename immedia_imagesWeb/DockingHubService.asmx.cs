using System.Web.Services;
using immedia_imagesDomain.docking;
using Newtonsoft.Json.Linq;
using Telerik.Web.UI;
using System.Collections.Generic;

namespace immedia_imagesWeb
{
    /// <summary>
    /// Summary description for DockingHubService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]
    public class DockingHubService : WebService
    {

        [WebMethod]
        public AutoCompleteBoxData GetAutocomplete(object context)
        {

            var searchString =
                ((Dictionary<string, object>)context)["Text"].ToString();

            var jArray = DockingHub.GetAutocomplete(searchString);

            var result = new List<AutoCompleteBoxItemData>();
            foreach (JValue obj in jArray)
            {
                var nodes = new AutoCompleteBoxItemData
                {
                    Text = obj.ToString(),
                    Value = obj.ToString()
                };

                obj.ToString();
            }

            var res = new AutoCompleteBoxData {
                Items = result.ToArray()
            };

            return res;
        }
    }
}
