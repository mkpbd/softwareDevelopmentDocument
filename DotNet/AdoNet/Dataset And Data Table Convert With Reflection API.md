
``` C#
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HDMS.Repository
{
    public static class DataConvater
    {
        public static DataSet ToDataSet<T>(this List<T> list)
        {
            DataSet ds = new DataSet();
            DataTable dt = new DataTable(typeof(T).Name);
            foreach (var property in typeof(T).GetProperties())
            {
                dt.Columns.Add(property.Name, property.PropertyType);
            }
            foreach (var item in list)
            {
                DataRow row = dt.NewRow();
                foreach (var property in item.GetType().GetProperties())
                {
                    row[property.Name] = property.GetValue(item, null);
                }

                dt.Rows.Add(row);
            }
            ds.Tables.Add(dt);
            return ds;
        }

        public static DataTable ToDataTable<T>(this List<T> list, string tableName)
        {
            DataTable dt = new DataTable(tableName);
            foreach (var property in typeof(T).GetProperties())
            {
                dt.Columns.Add(property.Name, Nullable.GetUnderlyingType(property.PropertyType) ?? property.PropertyType);
            }
            foreach (var item in list)
            {
                DataRow row = dt.NewRow();
                foreach (var property in item.GetType().GetProperties())
                {
                    if (property.GetValue(item) is null)
                    {
                        continue;
                    }
                    else row[property.Name] = property.GetValue(item, null);
                }

                dt.Rows.Add(row);
            }
            return dt;
        }

        public static DataTable ToDataTable<T>(T item, string tableName)
        {
            DataTable dt = new DataTable(tableName);
            foreach (var property in typeof(T).GetProperties())
            {
                dt.Columns.Add(property.Name, Nullable.GetUnderlyingType(property.PropertyType) ?? property.PropertyType);
            }
            DataRow row = dt.NewRow();
            foreach (var property in item.GetType().GetProperties())
            {
                if (property.GetValue(item) is null)
                {
                    continue;
                }
                else row[property.Name] = property.GetValue(item, null);
            }

            dt.Rows.Add(row);
            return dt;
        }
    }
}


```

