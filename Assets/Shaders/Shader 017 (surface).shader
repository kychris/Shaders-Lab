Shader "Custom/Shader 017 (surface)"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _ColorStrength ("Color Strength", Range(1,4)) = 1
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        // _Position("World Position", Vector) = (0, 0, 0, 0)
        // _Radius("Sphere Radius", range(0, 100)) = 0
        // _Softness("Sphere Softness", Range(0, 100)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos; //world position
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        half _ColorStrength;

        //mask variables
        uniform float4 _Position;
        uniform half _Radius; //can be half to reduce space
        uniform half  _Softness;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //Color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;   
            //Grayscale
            half grayscale = (c.r + c.g + c.b) * 0.333; //divide slow, "half" is half of float
            fixed3 c_grey = fixed3(grayscale, grayscale, grayscale); //gray texture

            half dist = distance(_Position, IN.worldPos);
            half sum = saturate((dist - _Radius) / -_Softness); 
            fixed4 lerpColor = lerp(fixed4(c_grey, 1), c * _ColorStrength, sum);

            o.Albedo = lerpColor.rgb;
            o.Alpha = c.a;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
