Shader "Unlit/Grid"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (0.,0.,1.,1.)
        _Bands ("Bands", Int) = 11
        _Thickness ("Thickness", Range(0., 1.)) = .1
        _SpeedX("Speed", Range(0., 10.)) = 0.
        _SpeedY("Speed", Range(0., 10.)) = 0.
        _Angle ("Angle", Float) = 0.
        _Offset ("Offset", Float) = 0.
        _Sensitivity("Sensitivity", Range(0., 1.)) = .1
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _Color;
            int _Bands;
            float _Thickness;
            float _SpeedX;
            float _SpeedY;
            float _Angle;
            float _Offset;
            float _Sensitivity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float2 rotate(float2 v, float a) {
                float s = sin(a);
                float c = cos(a);
                float2x2 m = float2x2(c, -s, s, c);
                return mul(m, v);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float speedX = 0.;
                float speedY = 0.;
                float4 panelColor = float4(1., 0., 1., 1.);
                float scale = 11.;

                float2 uv = i.uv;
                uv += .05 * _Thickness;
                uv *= scale;
                uv.x += _Time.y * _SpeedX +_Offset * _Sensitivity;
                uv.y += _Time.y * _SpeedY;
                float grid = 0.0;
                float linesX = step(_Thickness, frac(uv.x));
                float linesY = step(_Thickness, frac(uv.y));
                grid += linesX * linesY;

                float3 color = _Color.xyz * grid;
                return float4(color, 1.);
            }
            ENDCG
        }
    }
}
