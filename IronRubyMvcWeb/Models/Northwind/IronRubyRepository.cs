﻿using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Collections.Generic;
using IronRubyMvcWeb.Models.Northwind;

namespace IronRubyMvcWeb.Models {
    // Workaround for limitations in our current binder implementation
    public class IronRubyRepository : NorthwindRepository {
        public List<Category> GetCategories() {
            return Categories.ToList();
        }

        public Category GetCategory(string name) {
            return Categories.SingleOrDefault(c => c.CategoryName == name);
        }

        public List<Product> GetProductsForCategory(string name) {
            var category = GetCategory(name);
            var products = from p in Products
                           where p.CategoryID == category.CategoryID
                           select p;

            return products.ToList();
        }

        public Product GetProduct(int id) {
            return Products.Single(p => p.ProductID == id);
        }

        public Product GetProduct(string id) {
            Product product = Products.SingleOrDefault(p => p.ProductID == int.Parse(id));
            return product;
        }
    }
}
