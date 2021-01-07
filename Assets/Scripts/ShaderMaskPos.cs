using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderMaskPos : MonoBehaviour
{
    new Camera camera;
    RaycastHit hit;
    Ray ray;
    Vector3 mousePos, smoothPoint;
    public float radius, softness, smoothSpeed, scaleFactor;

    // Start is called before the first frame update
    void Start()
    {
        camera = gameObject.GetComponent<Camera>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.UpArrow))
        {
            radius += scaleFactor * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            radius -= scaleFactor * Time.deltaTime;
        }

        Mathf.Clamp(radius, 0, 100); //restrict radius

        mousePos = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0);
        ray = camera.ScreenPointToRay(mousePos);

        if (Physics.Raycast(ray, out hit))
        {
            smoothPoint = Vector3.MoveTowards(smoothPoint, hit.point, smoothSpeed * Time.deltaTime);
            Vector4 pos = new Vector4(smoothPoint.x, smoothPoint.y, smoothPoint.z, 0);
            Shader.SetGlobalVector("_Position", pos);
        }
        Shader.SetGlobalFloat("_Radius", radius);
    }
}
