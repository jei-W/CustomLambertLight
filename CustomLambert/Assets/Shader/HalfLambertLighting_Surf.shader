Shader "Custom/SurfaceShader/HalfLambertL"
{
    Properties
    {
		_MainTex ("Albedo", 2D) = "whith" {}
		_BumpMap ("Normal", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf CustomHalfLambert

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

		float4 LightingCustomHalfLambert (SurfaceOutput s, float3 lightDir, float atten)
		{
			float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
			// half lambert 공식은 빛을 받지 않는 부분이 극히 적기 때문에, 일반적으로 제곱하여 내적값이 0에 수렴하는 부분을 늘려 사용한다 
			ndotl = pow(ndotl, 3);

			float4 result;
			result.rgb = s.Albedo * ndotl * _LightColor0.rgb * atten;
			result.a = s.Alpha;

			return result;
		}
        ENDCG
    }
    FallBack "Diffuse"
}
