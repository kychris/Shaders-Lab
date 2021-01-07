// Shader that brightens when mouse is close

Shader "Custom/Flashlight"
{
    Properties {
       _Color ("Color", Color ) = (1,1,1,1)
       _Gloss ("Gloss", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag 

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL; //internally it is TEXCOORD1
                float3 worldPos : TEXCOORD2;
            };

            float4 _Color;
            float _Gloss;
            uniform float3 _MousePos;

            float Posterize(float steps, float val) 
            {
                return floor(val * steps) / steps;
            }

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv0 = v.uv0;
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex); //matrix multiply to get world pos of vertex
                return o;
            }

            fixed4 frag (VertexOutput o) : SV_Target
            {
                //glow values
                float dist = distance(_MousePos, o.worldPos);
                float glow = max(0, (1-dist));

                float2 uv = o.uv0;
                float3 normal = normalize(o.normal);

                //lighting
                float3 LightDir = _WorldSpaceLightPos0; 
                float3 LightColor = _LightColor0;

                //diffuse light
                float3 diffuseFallout = max(0, dot(LightDir, normal)); //cos(theta) of the angle between light and normal 
                diffuseFallout = Posterize(4, diffuseFallout); //apply falloff to diffuse
                float3 diffuseLight = LightColor * diffuseFallout;  //apply color to diffuse light
                
                //ambient light
                float3 ambientLight = float3(0.2, 0.1, 0.0);

                //specular light 
                float3 camPos = _WorldSpaceCameraPos;
                float3 fragToCam = camPos - o.worldPos;
                float3 viewDir = normalize(fragToCam);
                float3 viewReflect = reflect(-viewDir, normal); //reflect of view vector on surface
                float3 specularLight = max(0, dot(viewReflect, LightDir));  
                specularLight = pow(specularLight, _Gloss); //apply shininess
                specularLight = Posterize(4, specularLight);
                specularLight = specularLight * LightColor;

                //material
                float3 compositeLight = diffuseLight + ambientLight;
                compositeLight = compositeLight * _Color.rgb + specularLight + glow; 

                return float4(compositeLight, 0);
            }
            ENDCG
        }
    }
}
