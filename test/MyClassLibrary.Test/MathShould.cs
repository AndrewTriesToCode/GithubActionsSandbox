using Xunit;

namespace MyClassLibrary.Test
{
    public class MathShould
    {
        [Theory]
        [InlineData(2, 4)]
        [InlineData(-4, 0)]
        [InlineData(1234, 12)]
        public void AddTwoNumber(int a, int b)
        {
            Assert.Equal(a+b, Math.Add(a,b));
        }
    }
}