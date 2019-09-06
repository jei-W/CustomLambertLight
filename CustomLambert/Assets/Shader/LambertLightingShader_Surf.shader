Shader "Custom/SurfaceShader/LambertLightingShader_Surf"
{
    Properties
    {
		_MainTex ("Albedo", 2D) = "white" {}
		_BumpMap ("Normal", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf CustomLambert

        sampler2D _MainTex;
		sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal( tex2D(_BumpMap, IN.uv_BumpMap) );
			o.Alpha = c.a;
        }

		float4 LightingCustomLambert (SurfaceOutput s, float3 lightDir, float atten)
		{
			// 노멀벡터와 조명 벡터의 내적 : 180도 일 때 값은 -1이고, 0도 일 때 값은 1
			float ndotl = dot(s.Normal, lightDir);
			// 내적 값이 -1 ~ 1 사이로 나오는 것을 0 ~ 1 사이 값으로 바꿔주자
			// saturate를 이용하여 사이각 90도 이상이면 시꺼멓다
			ndotl = saturate(ndotl);

			float4 result;
			// _LightColor0는 유니티에 내장되어있는 변수 : 조명의 색상, 강도
			result.rgb = s.Albedo * ndotl * _LightColor0.rgb * atten;
			result.a = s.Alpha;

			return result;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
