using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderGlow : MonoBehaviour
{

    Plane p;
    Vector2 mousePos;
    Camera camera;
    Ray ray;

    // Start is called before the first frame update
    void Start()
    {
        p = new Plane(Vector3.up, Vector3.zero); //plane on xz plane
        camera = gameObject.GetComponent<Camera>();
    }

    // Update is called once per frame
    void Update()
    {
        mousePos = Input.mousePosition;
        // Debug.Log(mousePos);
        ray = camera.ScreenPointToRay(mousePos);
        if (p.Raycast(ray, out float enterDist))
        {
            Vector3 worldMousePos = ray.GetPoint(enterDist);
            Shader.SetGlobalVector("_MousePos", worldMousePos);
        }
    }
}

