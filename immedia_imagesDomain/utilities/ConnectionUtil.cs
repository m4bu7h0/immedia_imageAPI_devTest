using System.Data;
using System.Configuration;
using System.Data.SqlClient;

namespace immedia_imagesDomain.utilities {
    class ConnectionUtil {

        internal static IDbConnection Connection {
            get {

                var connectConfig =
                    ConfigurationManager
                    .ConnectionStrings["immediaDB"]
                    .ConnectionString;
                return new SqlConnection(connectConfig);
            }
        }
    }
}
