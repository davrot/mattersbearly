import React from 'react';
import type {CSSProperties} from 'react';
import {useIntl} from 'react-intl';

export default function MattermostLogo(props: React.HTMLAttributes<HTMLSpanElement>) {
    const {formatMessage} = useIntl();
    return (
        <span {...props}>
            <svg
                version='1.1'
                viewBox='0 0 25 25' // Matches your new file's coordinate system
                role='img'
                aria-label={formatMessage({id: 'generic_icons.mattermost', defaultMessage: 'Mattersbearly Logo'})}
                style={{width: '100%', height: '100%'}} // Ensures it fills the container
            >
                <ellipse
                    style={blackFill}
                    cx="12.076794"
                    cy="5.1979713"
                    rx="0.47136503"
                    ry="0.34538791" 
                />
                <g transform="matrix(0.04340964,0,0,0.04340964,-2.0356331,-1.3763251)" style={blackFill}>
                    <path
                        d="m 161.20601,525.13026 c -13.27672,-3.69037 ... z" // Shortened for brevity, use your full path string here
                        style={blackFill}
                    />
                    <ellipse
                        style={blackFill}
                        cx="163.61784"
                        cy="542.83911"
                        rx="56.363335"
                        ry="14.227638" 
                    />
                    <circle
                        style={blackFill}
                        cx="219.98119"
                        cy="196.99808"
                        r="18.479986" 
                    />
                    <circle
                        style={blackFill}
                        cx="458.16409"
                        cy="206.1998"
                        r="18.479986" 
                    />
                </g>
            </svg>
        </span>
    );
}

const blackFill: CSSProperties = {
    fill: '#000000',
    stroke: '#000000',
    fillOpacity: 1,
};

