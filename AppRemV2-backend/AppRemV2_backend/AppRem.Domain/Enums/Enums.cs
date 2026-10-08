

using System.Runtime.Serialization;

namespace AppRem.Domain.Enums
{
        public enum SalesMethod
        {
        [EnumMember(Value = "Unidad")]
        Unidad,
        [EnumMember(Value = "Peso")]
        Peso,
        [EnumMember(Value = "Metro")]
        Metro

        }
}
