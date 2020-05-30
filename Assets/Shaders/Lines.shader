Shader "Unlit/Lines"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1.,1.,1.,1.)
        _Bands ("Bands", Int) = 11
        _Thickness ("Thickness", Range(0., 1.)) = .5
        _Speed("Speed", Range(0., 10.)) = 1.
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
            float _Speed;
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
                float2 uv = i.uv;
                int numBands = _Bands;
                float thickness = _Thickness;
                float angle = radians(_Angle);
                uv = rotate(uv, angle);
                float lines = step(thickness, frac(uv.y * numBands + _Time.y * _Speed + _Offset * _Sensitivity));
                return _Color * lines;
            }
            ENDCG
        }
    }
}
