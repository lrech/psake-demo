using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using WebApplication.Controllers;
using Xunit;
using Assert = Microsoft.VisualStudio.TestTools.UnitTesting.Assert;

namespace WebApplication.xUnitTests.Controllers
{
   public class HomeControllerTest
   {
      [Fact]
      public void Contact( )
      {
         // Arrange
         HomeController controller = new HomeController( );

         // Act
         ViewResult result = controller.Contact( ) as ViewResult;

         // Assert
         Assert.IsNotNull( result );
      }
   }
}
